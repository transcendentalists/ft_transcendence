import { App } from "srcs/internal";

export let TournamentMatchCardListView = Backbone.View.extend({
  el: "#my-tournaments-view",
  defaultText: "<span>현재 참여중인 토너먼트가 없습니다.</span>",

  initialize: function () {
    this.child_views = [];
  },

  render: function (tournament_matches) {
    if (!tournament_matches || tournament_matches.length === 0)
      this.$el.html(this.defaultText);
    else {
      this.$el.empty();
      tournament_matches.forEach(this.addOne, this);
    }
    return this;
  },

  addOne: function (tournament_match) {
    if (this.child_views.length == 0) this.$el.empty();
    let tournament_match_card_view = new App.View.TournamentMatchCardView();
    this.child_views.push(tournament_match_card_view);
    this.$el.append(tournament_match_card_view.render(tournament_match).$el);
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
