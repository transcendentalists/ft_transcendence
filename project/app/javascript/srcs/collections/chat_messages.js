import { ChatMessage } from "srcs/models/chat_message";

export let ChatMessages = Backbone.Collection.extend({
  model: ChatMessage,

  initialize: function (options) {
    this.current_user = options.current_user;
    this.chat_user = options.chat_user;
  },

  url: function () {
    return `/api/users/${this.current_user.id}/direct_chat_rooms/${this.chat_user.id}`;
  },

  parse: function (response) {
    return response.chat_messages;
  },
});
