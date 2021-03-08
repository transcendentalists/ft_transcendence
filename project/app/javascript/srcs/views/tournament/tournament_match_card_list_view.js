import { App } from "srcs/internal";

export let TournamentMatchCardListView = Backbone.View.extend({
  initialize: function () {
    this.child_views = [];
  },

  addOne: function (tournament_match) {
    if (this.child_views.length == 0) this.$el.empty();
    let tournament_match_card_view = new App.View.TournamentMatchCardView();
    this.child_views.push(tournament_match_card_view);
    this.$el.append(tournament_match_card_view.render(tournament_match).$el);
  },

  render: function (tournament_matches) {
    this.$el.empty();
    tournament_matches.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
