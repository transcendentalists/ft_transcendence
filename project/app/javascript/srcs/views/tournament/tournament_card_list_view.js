import { App } from "srcs/internal";

export let TournamentCardListView = Backbone.View.extend({
  initialize: function () {
    this.child_views = [];
  },

  addOne: function (tournament) {
    let tournament_card_view = new App.View.TournamentCardView();
    this.child_views.push(tournament_card_view);
    this.$el.append(tournament_card_view.render(tournament).$el);
  },

  render: function (tournaments) {
    this.$el.empty();
    tournaments.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
