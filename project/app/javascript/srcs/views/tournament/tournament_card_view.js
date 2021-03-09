import { Helper } from "srcs/internal";

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
    const present = new Date();
    const start = new Date(data.start_date);
    data.can_register_at_now =
      present.toLocaleDateString() != start.toLocaleDateString();
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
    this.remove();
  },
});
