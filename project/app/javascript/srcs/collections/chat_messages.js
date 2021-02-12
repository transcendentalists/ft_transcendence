import { App, Helper } from "srcs/internal";
import { ChatMessage } from "srcs/models/chat_message";

export let ChatMessages = Backbone.Collection.extend({
  model: ChatMessage,

  parse: function (response) {
    return response.chat_messages;
  },
});
