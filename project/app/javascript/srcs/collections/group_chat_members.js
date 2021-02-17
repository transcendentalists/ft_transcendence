import { Helper } from "srcs/helper";
import { App } from "../internal";
import { User } from "../models/user";

export let GroupChatMembers = Backbone.Collection.extend({
  model: User,

  url: function (member_id) {
    return `group_chat_rooms/${this.room_id}/memberships/${member_id}`;
  },

  changeMembershipRequest: function (
    member,
    params = { position: null, mute: null }
  ) {
    Helper.fetch(this.url(member.id), {
      method: "PATCH",
      body: {
        admin_id: App.current_user.id,
        member_id: member.id,
        position: params.position,
        mute: params.mute,
      },
    });
  },

  giveAdminPosition: function (params) {
    if (params.current_user.get("position") != "owner") return;
    if (params.member.get("position") != "member") return;
    this.changeMembershipRequest(params.member, { position: "admin" });
  },

  removeAdminPosition: function (params) {
    if (params.current_user.get("position") != "owner") return;
    if (params.member.get("position") != "admin") return;
    this.changeMembershipRequest(params.member, { position: "member" });
  },

  toggleMute: function (params) {
    if (!["owner", "admin"].includes(params.current_user.get("position")))
      return;
    if (params.member.get("position") == "owner") return;
    this.changeMembershipRequest(params.member, {
      mute: !params.member.get("mute"),
    });
  },
});
