import { App } from "srcs/internal";

export let DirectChatRoom = Backbone.Model.extend({
  initialize: function (options) {
    this.friend_user = options["friend_user"];
    this.parent = options["parent"];
    this.status = "stop";
    this.chat_messages = new App.Collection.ChatMessages({
      url:
        "/api/users/" +
        App.current_user.id +
        "/direct_chat_rooms/" +
        this.friend_user.id,
    });
    this.chat_message_list_view = null;
  },

  start: function () {
    this.status = "run";
    this.chat_message_list_view = new App.View.ChatMessageListView();
    this.chat_messages.fetch();
  },

  stop: function () {
    this.status = "stop";
    if (this.chat_message_list_view) this.chat_message_list_view.close();
  },

  close: function () {
    if (this.status == "run") this.stop();
    this.chat_message_list_view = null;
    this.chat_messages = null;
  },
});
