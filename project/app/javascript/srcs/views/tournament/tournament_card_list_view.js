import { App } from "srcs/internal";

export let TournamentCardListView = Backbone.View.extend({
  initialize: function (options) {
    this.parent = options.parent;
    this.child_views = [];
  },

  render: function (tournaments) {
    this.$el.empty();
    tournaments.forEach(this.addOne, this);
    return this;
  },

  addOne: function (tournament) {
    if (this.child_views.length == 0) this.$el.empty();
    let tournament_card_view = new App.View.TournamentCardView({
      parent: this,
    });
    this.child_views.push(tournament_card_view);
    this.$el.append(tournament_card_view.render(tournament).$el);
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

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
