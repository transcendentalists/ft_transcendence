import { App, Helper } from "srcs/internal";

export let TournamentIndexView = Backbone.View.extend({
  template: _.template($("#tournament-index-view-template").html()),
  id: "tournament-index-view",
  className: "flex-container column-direction center-aligned top-margin",

  initialize: function () {
    this.my_tournaments = [];
    this.open_tournaments = [];
    this.my_tournaments_view = null;
    this.open_tournaments_view = null;
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

  renderTournamentsCallBack: function (data) {
    this.parseTournamentsData(data);

    this.my_tournaments_view = new App.View.TournamentMatchCardListView().setElement(
      this.$("#my-tournaments-view")
    );
    if (this.my_tournaments.length > 0) {
      this.my_tournaments_view.render(this.my_tournaments);
    }

    this.open_tournaments_view = new App.View.TournamentCardListView({
      parent: this,
    }).setElement(this.$("#open-tournaments-view"));
    if (this.open_tournaments.length > 0) {
      this.open_tournaments_view.render(this.open_tournaments);
    }
  },

  render: function () {
    this.$el.html(this.template());
    Helper.fetch("tournaments?for=tournament_index", {
      success_callback: this.renderTournamentsCallBack.bind(this),
    });
    return this;
  },

  close: function () {
    this.my_tournaments = null;
    this.open_tournaments = null;
    if (this.my_tournaments_view) this.my_tournaments_view.close();
    if (this.open_tournaments_view) this.open_tournaments_view.close();
    this.remove();
  },
});
