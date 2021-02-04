import { Helper } from "srcs/internal";

export let DirectChatView = Backbone.View.extend({
  template: _.template($("#direct-chat-view-template").html()),
  className: "ui text container",
  el: "#direct-chat-view",

  events: {
    "click .blue.labeled.button": "test1",
    "click .ui.button": "test2",
  },

  test2: function () {
    Helper.input({
      subject: "인풋모달",
      description: "인풋테스트 콜백없음",
    });
  },

  test1: function () {
    Helper.input({
      subject: "인풋모달",
      description: "인풋테스트 콜백있음",
      success_callback: function (description) {
        console.log(description);
      },
    });
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