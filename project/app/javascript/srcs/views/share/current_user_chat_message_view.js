import { App, Helper } from "srcs/internal";

export let CurrentUserChatMessageView = Backbone.View.extend({
  template: _.template($("#current-user-chat-message-view-template").html()),
  className: "comment current-user",

  initialize: function () {},

  render: function () {
    // this.$el.html(this.template(this.model.toJSON()));
    this.$el.html(this.template());
    return this;
  },

  close: function () {
    this.remove();
  },
});
