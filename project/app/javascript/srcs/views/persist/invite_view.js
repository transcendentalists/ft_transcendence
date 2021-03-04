import { App, Helper, DualHelper } from "srcs/internal";

export let InviteView = Backbone.View.extend({
  template: _.template($("#invite-view-template").html()),
  el: "#invite-view",

  events: {
    "click [data-invite-value=approve]": "approve",
    "click [data-invite-value=decline]": "decline",
  },

  initialize: function () {
    this.invited_game = null;
    this.$el.hide();
  },

  approve: function () {
    const url =
      "#/matches?match_type=dual&challenger_id=" +
      this.invited_game.profile.id +
      "&rule_id=" +
      this.invited_game.rule_id +
      "&target_score=" +
      this.invited_game.target_score;
    App.router.navigate(url);
    this.close();
  },

  decline: function () {
    App.notification_channel.dualRequestDecline(this.invited_game.profile.id);
    this.close();
  },

  render: function (invited_game) {
    if (DualHelper.addListenToUserModel(this, invited_game.profile.id)) {
      this.invited_game = invited_game;
      App.current_user.working = true;
      this.$el.html(
        this.template({
          profile: invited_game.profile,
          rule_name: invited_game.rule_name,
          target_score: invited_game.target_score,
        })
      );
      this.$el.show();
    }
  },

  close: function () {
    this.stopListening();
    App.current_user.working = false;
    this.invited_game = null;
    this.$el.hide();
  },
});
