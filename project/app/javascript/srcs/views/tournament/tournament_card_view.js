export let TournamentCardView = Backbone.View.extend({
  template: _.template($("#tournament-card-view-template").html()),
  className:
    "ui segment tournament-card flex-container column-direction center-aligned",

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
