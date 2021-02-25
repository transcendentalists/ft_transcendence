export let TournamentMatchCardView = Backbone.View.extend({
  template: _.template($("#tournament-match-card-view-template").html()),
  className:
    "ui segment tournament-match-card flex-container column-direction center-aligned",

  initialize: function () {},

  render: function (data) {
    this.$el.html(this.template(data));
    return this;
  },

  close: function () {
    this.$el.empty();
    this.remove();
  },
});
