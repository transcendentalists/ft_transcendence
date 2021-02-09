import { Helper } from "srcs/internal";

export let DirectChatView = Backbone.View.extend({
  template: _.template($("#direct-chat-view-template").html()),
  className: "ui text container",
  el: "#direct-chat-view",

  events: {
    "click .blue.labeled.button": "test1",
    "click .ui.button": "test2",
  },

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
