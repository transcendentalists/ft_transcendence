import { App } from "srcs/internal";

export let TournamentCardListView = Backbone.View.extend({
  initialize: function (options) {
    this.parent = options.parent;
    this.child_views = [];
  },

  addOne: function (tournament) {
    let child_view = new App.View.TournamentCardView({ parent: this });
    this.child_views.push(child_view);
    this.$el.append(child_view.render(tournament).$el);
  },

  showDefaultMessage: function () {
    this.$el.html("현재 열려있는 토너먼트가 없습니다.");
  },

  moveCardToMyTournamentsView: function (options) {
    this.parent.my_tournaments_view.addOne(options.data.tournament_match);
    options.tournament_card_view.close();
    if (this.$el.find(".tournament-card").length == 0)
      this.showDefaultMessage();
  },

  render: function (tournaments) {
    this.$el.html("");
    tournaments.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
