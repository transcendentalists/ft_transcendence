import { App, Helper } from "srcs/internal";

export let RequestView = Backbone.View.extend({
  template: _.template($("#request-view-template").html()),
  el: "#request-view",

  events: {
    "click [data-request-value=cancel]": "cancel",
  },

  initialize: function () {
    this.enemy = null;
    this.$el.hide();
  },

  cancel: function () {
    App.notification_channel.dualRequestCancel(this.enemy.id);
    this.close();
  },

  render: function (enemy) {
    this.enemy = enemy;
    this.$el.empty();
    this.$el.html(this.template(enemy));
    this.$el.show();
  },

  close: function () {
    this.enemy = null;
    this.$el.hide();
  },
});
