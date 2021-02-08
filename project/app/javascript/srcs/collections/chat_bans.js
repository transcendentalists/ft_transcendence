import { App, Helper } from "../internal";
import { ChatBan } from "../models/chat_ban";

export let ChatBans = Backbone.Collection.extend({
  model: ChatBan,

  url: function () {
    return `/api/users/${App.current_user.id}/chat_bans`;
  },

  parse: function (response) {
    return response.chatBans;
  },

  isUserChatBanned: function (user_id) {
    if (typeof this.findWhere({ banned_user_id: user_id }) == "undefined")
      return false;
    else return true;
  },

  createChatBan: function (user_id) {
    Helper.fetch(
      `users/${App.current_user.id}/chat_bans`,
      this.createChatBanParams(user_id)
    );
  },

  createChatBanParams: function (user_id) {
    return {
      method: "POST",
      success_callback: this.fetch.bind(this),
      body: {
        banned_user: {
          id: user_id,
        },
      },
    };
  },

  destroyChatBan: function (user_id) {
    Helper.fetch(
      `users/${App.current_user.id}/chat_bans/${user_id}`,
      this.destroyChatBanParams()
    );
  },

  destroyChatBanParams: function () {
    return {
      method: "DELETE",
      success_callback: this.fetch.bind(this),
    };
  },
});
