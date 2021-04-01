import { App, Helper } from "srcs/internal";
import { User } from "srcs/models/user";

export let GroupChatMembers = Backbone.Collection.extend({
  model: User,

  url: function (membership_id) {
    return `group_chat_rooms/${this.room_id}/memberships/${membership_id}`;
  },

  initialize: function (chat_members, options) {
    chat_members.forEach((user) => this.add(new User(user)));
    if (Object.keys(options) === 0) return;
    this.room_id = options.room_id;
  },

  changeMembershipRequest: function (
    member,
    params = { position: null, mute: null }
  ) {
    Helper.fetch(this.url(member.get("membership_id")), {
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

  renderBanTimeModal: function (chat_room_member) {
    Helper.input({
      subject: "멤버 밴",
      description:
        "지정한 유저를 밴 시간만큼 채팅룸에 들어올 수 없게 합니다.<br>\
        미입력시 해당 유저는 강퇴되고 바로 다시 들어올 수 있습니다. (단위: 분)",
      success_callback: function (ban_time) {
        this.letOutOfChatRoom(chat_room_member, ban_time);
      }.bind(this),
    });
  },

  letOutOfChatRoom: async function (chat_room_member, ban_time = 0) {
    await Helper.fetch(
      `group_chat_memberships/${chat_room_member.get("membership_id")}`,
      {
        method: "DELETE",
        body: {
          ban_time: ban_time,
        },
        fail_callback: Helper.defaultErrorHandler,
      }
    );
  },
});
