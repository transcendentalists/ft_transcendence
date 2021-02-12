import { App, Helper } from "srcs/internal";

export let DirectChatView = Backbone.View.extend({
  template: _.template($("#direct-chat-view-template").html()),
  className: "ui text container",
  el: "#direct-chat-view",
  events: {
    "click .close.icon": "hide",
    "click .submit.button": "send",
  },

  initialize: function () {
    this.$el.hide();
    this.chat_room_list = [];
    this.chat_room = null;
  },

  send: function () {
    let msg = $("#reply-field").val();
    if (msg == "") return;
    $("#reply-field").val("");
    this.chat_room.send({
      image_url: App.current_user.get("image_url"),
      name: App.current_user.get("name"),
      created_at: new Date(),
      message: msg,
      user_id: App.current_user.get("id"),
    });
  },

  render: function (chat_user) {
    this.$el.html(this.template(chat_user.attributes));

    if (this.chat_room) this.chat_room.stop();

    this.chat_room = this.chat_room_list.find(
      (room) => room.chat_user.get("id") == chat_user.get("id")
    );
    if (this.chat_room == undefined) {
      this.chat_room = new App.Model.DirectChatRoom({
        parent: this,
        chat_user: chat_user,
      });
      this.chat_room_list.push(this.chat_room);
    }

    this.chat_room.start();
    this.$el.show();
  },

  hide: function () {
    if (this.chat_room) this.chat_room.stop();
    this.$el.empty();
    this.$el.hide();
  },

  close: function () {
    this.chat_room_list.forEach((chat_room) => chat_room.close());
    this.chat_room_list = [];
    this.$el.hide();
    this.remove();
  },
});
