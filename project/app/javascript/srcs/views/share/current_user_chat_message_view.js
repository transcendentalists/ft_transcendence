import { App, Helper } from "srcs/internal";

export let CurrentUserChatMessageView = Backbone.View.extend({
  template: _.template($("#current-user-chat-message-template").html()),
  className: "comment",

  initialize: function () {},

  render: function () {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

  close: function () {
    this.remove();
  },
});
