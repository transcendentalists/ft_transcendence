import { App, Helper } from "../internal";
import { ChatBan } from "../models/chat_ban";

export let ChatBans = Backbone.Collection.extend({
  model: ChatBan,

  url: function () {
    return `/api/users/${App.current_user.id}/chat_bans`;
  },

  parse: function (response) {
    return response.chat_bans;
  },

  isUserChatBanned: function (user_id) {
    if (typeof this.findWhere({ banned_user_id: user_id }) == "undefined")
      return false;
    else return true;
  },

  toggleChatBan: function (user_id) {
    if (user_id == App.current_user.id) return;
    if (this.findWhere({ banned_user_id: user_id }) == undefined)
      this.createChatBan(user_id);
    else this.destroyChatBan(user_id);
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
        banned_user_id: user_id,
      },
    };
  },

  destroyChatBan: function (user_id) {
    let chat_ban_id = this.findWhere({
      user_id: App.current_user.id,
      banned_user_id: user_id,
    }).get("id");

    Helper.fetch(
      `users/${App.current_user.id}/chat_bans/${chat_ban_id}`,
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
