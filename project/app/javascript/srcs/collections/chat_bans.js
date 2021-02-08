import { App } from "../internal";
import { ChatBan } from "../models/chat_ban";

export let ChatBans = Backbone.Collection.extend({
  model: ChatBan,

  url: function () {
    return `/api/users/${App.current_user.id}/chat_bans`;
  },

  parse: function (response) {
    return response.chatBans;
  },
});
