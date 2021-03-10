export let WarStatusView = Backbone.View.extend({
  template: _.template($("#war-status-view-template").html()),

  render: function (war_status) {
    war_status.total_point =
      war_status.my_guild_point + war_status.opponent_guild_point;
    this.$el.html(this.template(war_status));
    $("#my-guild-point").progress();
    $("#opponent-guild-point").progress();
    $("#no-reply-count").progress();
    return this;
  },

  close: function () {
    this.remove();
  },
});
