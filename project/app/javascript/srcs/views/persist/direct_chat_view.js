import { Helper } from "srcs/internal";

export let DirectChatView = Backbone.View.extend({
  template: _.template($("#direct-chat-view-template").html()),
  className: "ui text container",
  el: "#direct-chat-view",

  initialize: function () {
    this.$el.hide();
    this.chat_room_list = [];
  },

  render: function (friend_user) {
    this.$el.html(this.template(friend_user.attributes));
    this.$el.show();
  },

  close: function () {
    this.chat_room_list = [];
    this.$el.empty();
    this.$el.hide();
  },
});
