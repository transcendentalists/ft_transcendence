import { Helper } from "srcs/internal";
import { CurrentUserChatMessageView } from "../share/current_user_chat_message_view";

export let DirectChatView = Backbone.View.extend({
  template: _.template($("#direct-chat-view-template").html()),
  className: "ui text container",
  el: "#direct-chat-view",

  initialize: function () {
    this.$el.hide();
  },

  render: function () {
    this.$el.html(this.template());
    this.$el.show();
  },

  close: function () {
    this.$el.empty();
    this.$el.hide();
  },
});
