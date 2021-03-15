import { App, Helper } from "srcs/internal";

export let TournamentIndexView = Backbone.View.extend({
  template: _.template($("#tournament-index-view-template").html()),
  id: "tournament-index-view",
  className: "flex-container column-direction center-aligned top-margin",

  initialize: function () {
    this.my_tournaments = [];
    this.open_tournaments = [];
    this.my_tournament_list_view = null;
    this.open_tournament_list_view = null;
  },

  render: function () {
    this.$el.html(this.template());
    Helper.fetch("tournaments?for=tournament_index", {
      success_callback: this.renderTournaments.bind(this),
    });
    return this;
  },

  renderTournaments: function (data) {
    this.parseTournamentsData(data);

    this.my_tournament_list_view = new App.View.TournamentMatchCardListView();
    this.my_tournament_list_view.render(this.my_tournaments);

    this.open_tournament_list_view = new App.View.TournamentCardListView({
      parent: this,
    });
    this.open_tournament_list_view.render(this.open_tournaments);
  },

  parseTournamentsData: function (data) {
    this.my_tournaments = _.filter(
      data.tournaments,
      (tournament) => tournament.current_user_next_match !== null
    );
    this.open_tournaments = _.filter(
      data.tournaments,
      (tournament) =>
        tournament.current_user_next_match === null &&
        tournament.status == "pending"
    );
  },

  close: function () {
    this.my_tournaments = null;
    this.open_tournaments = null;
    if (this.my_tournament_list_view) this.my_tournament_list_view.close();
    if (this.open_tournament_list_view) this.open_tournament_list_view.close();
    this.remove();
  },
});
