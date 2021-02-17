import { Helper } from "srcs/helper";
import { User } from "../models/user";

export let GroupChatMembers = Backbone.Collection.extend({
  url: "/api/users/",
  model: User,

  initialize: function (chat_members, options) {
    chat_members.forEach((user) => this.add(new User(user)));
    if (Object.keys(options) === 0) return;
    this.room_id = options.room_id;
  },

  letOutOfChatRoom: function (chat_room_member) {
    Helper.fetch(`api/group_chat_rooms/${this.room_id}/memberships`, {
      method: "DELETE",
      headers: Helper.current_user_header,
      successCallBack: function () {
        this.remove(chat_room_member);
      }.bind(this),
    });
  },
});
