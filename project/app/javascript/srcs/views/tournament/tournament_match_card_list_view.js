import { App } from "srcs/internal";
import { Helper } from "srcs/helper";

export let TournamentMatchCardListView = Backbone.View.extend({
  initialize: function () {
    this.child_views = [];
  },

  addOne: function (tournament_match) {
    let child_view = new App.View.TournamentMatchCardView();
    this.child_views.push(child_view);
    this.$el.append(child_view.render(tournament_match).$el);
  },

  render: function (tournament_matches) {
    this.$el.html("");
    tournament_matches.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
