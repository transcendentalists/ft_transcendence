import { App } from "srcs/internal";

export let DirectChatRoom = Backbone.Model.extend({
  initialize: function (options) {
    this.chat_user = options["chat_user"];
    this.parent = options["parent"];

    this.chat_messages = new App.Collection.ChatMessages();
    this.chat_messages.url =
      "/api/users/" +
      App.current_user.id +
      "/direct_chat_rooms/" +
      this.chat_user.id;

    const room_id =
      _.min([this.chat_user.id, App.current_user.id]) +
      "+" +
      _.max([this.chat_user.id, App.current_user.id]);

    this.chat_message_list_view = new App.View.ChatMessageListView({
      chat_user: this.chat_user,
      collection: this.chat_messages,
      room_id: room_id,
    });

    this.status = "not started";
  },

  send: function (current_user_message) {
    console.log(
      "🚀 ~ file: direct_chat_room.js ~ line 39 ~ current_user_message",
      current_user_message
    );
    this.chat_message_list_view.channel.speak(current_user_message);
  },

  start: function () {
    if (this.status == "run") return;

    this.chat_message_list_view
      .setElement($("#direct-chat-view .comments"))
      .render();

    console.log(
      "🚀 ~ file: direct_chat_room.js ~ line 48 ~ this.chat_message_list_view"
    );

    if (this.status == "stop") this.chat_messages.fetch();
    else if (this.status == "not started")
      this.chat_messages.fetch({ reset: true });

    console.log(
      "🚀 ~ file: direct_chat_room.js ~ line 56 ~ this.chat_message_list_view"
    );

    this.status = "run";
  },

  stop: function () {
    if (this.status != "run") return;
    this.chat_message_list_view.stop();
    this.status = "stop";
  },

  close: function () {
    this.chat_message_list_view.close();
    this.chat_message_list_view = null;
    this.chat_messages = null;
  },
});
