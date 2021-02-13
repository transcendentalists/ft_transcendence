import { App, Helper } from "srcs/internal";

export let InviteView = Backbone.View.extend({
  template: _.template($("#invite-view-template").html()),
  el: "#invite-view",

  events: {
    "click [data-invite-value=approve]": "approve",
    "click [data-invite-value=cancel]": "cancel",
  },

  initialize: function () {
    this.match_id = null;
    this.$el.hide();
  },

  approve: function () {
    App.router.navigate(`#/matches?match-type=dual&match-id=${this.match_id}`);
    this.close();
  },

  cancel: function () {
    Helper.fetch(`matches/${this.match_id}`, { method: "DELETE" });
    this.close();
  },

  render: function (data, match_id) {
    if (this.match_id) this.cancel();
    this.match_id = match_id;
    this.$el.empty();
    this.$el.html(this.template(data));
    this.$el.show();
  },

  close: function () {
    this.match_id = null;
    this.$el.hide();
  },
});
