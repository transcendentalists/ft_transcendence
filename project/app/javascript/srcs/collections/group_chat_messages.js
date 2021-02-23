import { ChatMessage } from "srcs/models/chat_message";

export let GroupChatMessages = Backbone.Collection.extend({
  model: ChatMessage,

  initialize: function (room_id) {
    this.room_id = room_id;
  },

  url: function () {
    return `/api/group_chat_rooms/${this.room_id}/chat_messages`;
  },

  parse: function (response) {
    return response.chat_messages;
  },
});
