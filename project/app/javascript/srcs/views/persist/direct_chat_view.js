import { Helper } from "srcs/internal";

export let DirectChatView = Backbone.View.extend({
  template: _.template($("#direct-chat-view-template").html()),
  className: "ui text container",
  el: "#direct-chat-view",
  events: {
    "click .close.icon": "hide",
  },

  initialize: function () {
    this.$el.hide();
    this.chat_room_list = [];
    this.chat_room = null;
  },

  render: function (chat_user) {
    this.$el.html(this.template(chat_user.attributes));

    this.chat_room = this.chat_room_list.find(
      (room) => room.chat_user.id == chat_user.id
    );
    if (this.chat_room == undefined) {
      this.chat_room = new App.Model.DirectChatRoom({
        parent: this,
        chat_user: chat_user,
      });
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
    this.hide();
    this.remove();
  },
});
