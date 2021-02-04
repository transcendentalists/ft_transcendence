import { App, Helper } from "srcs/internal";

export let ChatMessageView = Backbone.View.extend({
  template: _.template($("#chat-message-template").html()),
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
