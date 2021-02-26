import { Helper } from "srcs/helper";

export let TournamentCardView = Backbone.View.extend({
  template: _.template($("#tournament-card-view-template").html()),
  className: "tournament-card flex-container column-direction center-aligned",

  events: {
    ".register.button click": "registerTournament",
  },

  url: function (tournament_id) {
    return `tournaments/${tournament_id}/memberships`;
  },

  registerTournament: function (event) {
    let tournament_id = event.target.getAttribute("data-tournament-id");
    if (isNaN(tournament_id)) return;

    Helper.fetch(this.url(tournament_id), {
      method: "POST",
      success_callback: (data) => this.moveToMyTournamentsView(data),
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

  moveToMyTournamentsView: function (data) {
    this.parent.parent.my_tournaments_view.addOne(data);
    this.close();
  },

  close: function () {
    this.$el.empty();
    this.remove();
  },
});
