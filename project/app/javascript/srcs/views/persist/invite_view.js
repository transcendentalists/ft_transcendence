import { App, Helper } from "srcs/internal";

export let InviteView = Backbone.View.extend({
  template: _.template($("#invite-view-template").html()),
  el: "#invite-view",

  events: {
    "click [data-invite-value=approve]": "approve",
    "click [data-invite-value=decline]": "decline",
  },

  initialize: function () {
    this.data = null;
    this.$el.hide();
  },

  approve: function () {
    const url =
      "#/matches?match_type=dual&challenger_id=" +
      this.data.profile.id +
      "&rule_id=" +
      this.data.rule_id +
      "&target_score=" +
      this.data.target_score;
    App.router.navigate(url);
    this.close();
  },

  decline: function () {
    App.notification_channel.dualRequestDecline(this.data.profile.id);
    this.close();
  },

  render: function (data) {
    this.data = data;
    this.$el.html(this.template({profile: data.profile, rule_name: data.rule_name, target_score: data.target_score}));
    this.$el.show();
  },

  close: function () {
    this.data = null;
    this.$el.hide();
  },
});
