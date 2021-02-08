import { App } from "../internal";

export let ChatBan = Backbone.Model.extend({
  urlRoot: function () {
    return `/api/users/${App.current_user.id}/chat_bans`;
  },

  initialize: function () {},

  parse: function (response, options) {
    if (options.collection) {
      return response;
    } else {
      return response.chatBan;
    }
  },
});
