import { App, Helper } from "srcs/internal";

export let InviteView = Backbone.View.extend({
  template: _.template($("#invite-view-template").html()),
  el: "#invite-view",

  events: {
    "click [data-invite-value=approve]": "approve",
    "click [data-invite-value=decline]": "decline",
  },

  initialize: function () {
    this.challenger = null;
    this.$el.hide();
  },

  approve: function () {
    const url =
      "#/matches?match-type=dual&challenger-id=" +
      this.challenger.profile.id +
      "&rule-id=" +
      this.challenger.rule_id +
      "&target-score=" +
      this.challenger.target_score;
    App.router.navigate(url);
    this.close();
  },

  decline: function () {
    App.notification_channel.dualRequestDecline(this.challenger.profile.id);
    this.close();
  },

  render: function (challenger) {
    this.challenger = challenger;
    this.$el.empty();
    this.$el.html(this.template(challenger.profile));
    this.$el.show();
  },

  close: function () {
    this.challenger = null;
    this.$el.hide();
  },
});
