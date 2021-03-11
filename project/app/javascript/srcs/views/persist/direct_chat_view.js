import { App } from "srcs/internal";

export let DirectChatView = Backbone.View.extend({
  template: _.template($("#direct-chat-view-template").html()),
  className: "ui text container",
  el: "#direct-chat-view",
  events: {
    "click .close.icon": "hide",
    "click .submit.button": "send",
    "click .dual-join.button": "dual",
  },

  initialize: function () {
    this.$el.hide();
    this.chat_room_list = [];
    this.chat_room = null;
  },

  render: function (chat_user) {
    if (this.checkDuplicateOpenWith(chat_user)) return;
    if (this.chat_room) this.chat_room.stop();

    this.$el.html(this.template(chat_user.attributes));
    this.message_field = this.$(".reply-field");
    this.chat_room = this.findOrCreateChatRoomWith(chat_user);
    this.chat_room.start();
    this.$el.show();
    setTimeout(this.scrollDown.bind(this), 500);
  },

  checkDuplicateOpenWith: function (chat_user) {
    return (
      this.chat_room?.status == "run" &&
      chat_user.equalTo(this.chat_room.chat_user)
    );
  },

  findOrCreateChatRoomWith: function (chat_user) {
    this.chat_room = this.chat_room_list.find((room) =>
      room.chat_user.equalTo(chat_user)
    );
    if (!this.chat_room) {
      this.chat_room = new App.View.DirectChatRoomView({
        parent: this,
        chat_user: chat_user,
      });
      this.chat_room_list.push(this.chat_room);
    }
    return this.chat_room;
  },

  hide: function () {
    if (this.chat_room) this.chat_room.stop();
    this.$el.empty();
    this.$el.hide();
  },

  send: function () {
    let msg = this.message_field.val();
    if (msg == "") return;
    this.message_field.val("");
    this.chat_room.send({
      image_url: App.current_user.get("image_url"),
      name: App.current_user.get("name"),
      created_at: new Date(),
      message: msg,
      user_id: App.current_user.get("id"),
    });
  },

  dual: function () {
    App.current_user.dualRequestTo(this.chat_room.chat_user);
  },

  scrollDown: function () {
    this.chat_room.chat_message_list_view.scrollDown();
  },

  close: function () {
    this.chat_room_list.forEach((chat_room) => chat_room.close());
    this.chat_room_list = [];
    this.chat_room = null;
    this.$el.hide();
  },
});
