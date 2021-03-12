import { App } from "srcs/internal";

export let TournamentCardListView = Backbone.View.extend({
  el: "#open-tournaments-view",
  defaultText: "<span>현재 열려있는 토너먼트가 없습니다.</span>",
  initialize: function (options) {
    this.parent = options.parent;
    this.child_views = [];
  },

  render: function (tournaments) {
    if (!tournaments || tournaments.length === 0)
      this.$el.html(this.defaultText);
    else {
      this.$el.empty();
      tournaments.forEach(this.addOne, this);
    }
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
    this.$el.html(this.defaultText);
  },

  moveCardToMyTournamentsView: function (options) {
    this.parent.my_tournaments_view.addOne(options.data.tournament_match);
    options.tournament_card_view.close();
    if (this.$(".tournament-card").length == 0) this.showDefaultMessage();
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
