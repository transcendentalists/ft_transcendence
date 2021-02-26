import { Helper } from "srcs/helper";

export let TournamentCardView = Backbone.View.extend({
  template: _.template($("#tournament-card-view-template").html()),
  className: "tournament-card flex-container column-direction center-aligned",

  events: {
    "click .register.button": "registerTournament",
  },

  url: function (tournament_id) {
    return `tournaments/${tournament_id}/memberships`;
  },

  registerTournament: function (event) {
    let tournament_id = event.target.getAttribute("data-tournament-id");
    if (isNaN(tournament_id)) return;

    Helper.fetch(this.url(tournament_id), {
      method: "POST",
      success_callback: (data) => this.moveCardToMyTournamentsView(data),
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    });
  },

  initialize: function (options) {
    this.parent = options.parent;
  },

  render: function (data) {
    this.$el.html(this.template(data));
    return this;
  },

  moveCardToMyTournamentsView: function (data) {
    this.parent.moveCardToMyTournamentsView({
      data: data,
      tournament_card_view: this,
    });
  },

  close: function () {
    this.$el.empty();
    this.remove();
  },
});
