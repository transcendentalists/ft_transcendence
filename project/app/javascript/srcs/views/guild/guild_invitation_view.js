import { Helper } from "srcs/internal";

export let GuildInvitationView = Backbone.View.extend({
  template: _.template($("#guild-invitation-view-template").html()),
  className: "ui card mobile-only",
  events: {
    "click .approve.button": "approve",
    "click .decline.button": "decline",
  },

  initialize: function () {},

  approve: function () {
    this.close();
  },

  decline: function () {
    this.close();
  },

  render: function (data) {
    this.$el.html(this.template(data));
    return this;
  },

  close: function () {
    this.$el.empty();
    this.$el.remove();
  },
});
