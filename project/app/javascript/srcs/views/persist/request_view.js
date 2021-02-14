import { App, Helper } from "srcs/internal";

export let RequestView = Backbone.View.extend({
  template: _.template($("#request-view-template").html()),
  el: "#request-view",

  events: {
    "click [data-request-value=cancel]": "cancel",
  },

  initialize: function () {
    this.challenger = null;
    this.$el.hide();
  },

  cancel: function () {
    App.notification_channel.dualRequestCancel(this.challenger.id);
    this.close();
  },

  render: function (challenger) {
    this.challenger = challenger;
    this.$el.empty();
    this.$el.html(this.template(challenger));
    this.$el.show();
  },

  close: function () {
    this.challenger = null;
    this.$el.hide();
  },
});
