import { App, Helper, DualHelper } from "srcs/internal";

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
    if (DualHelper.addLitsenToUserModel(this, enemy.id)) {
      this.enemy = enemy;
      App.current_user.working = true;
      this.$el.html(this.template(enemy));
      this.$el.show();
    }
  },

  close: function () {
    this.stopListening();
    App.current_user.working = false;
    this.enemy = null;
    this.$el.hide();
  },
});
