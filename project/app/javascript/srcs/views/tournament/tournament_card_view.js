export let TournamentCardView = Backbone.View.extend({
  template: _.template($("#tournament-card-view-template").html()),
  className: "tournament-card flex-container column-direction center-aligned",

  initialize: function () {},

  render: function (data) {
    const present = new Date();
    const start = new Date(data.start_date);
    data.can_register_at_now =
      present.toLocaleDateString() != start.toLocaleDateString();
    this.$el.html(this.template(data));
    return this;
  },

  close: function () {
    this.remove();
  },
});
