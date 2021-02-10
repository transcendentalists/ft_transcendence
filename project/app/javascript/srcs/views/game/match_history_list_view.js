import { App } from "srcs/internal";

export let MatchHistoryListView = Backbone.View.extend({
  el: ".match-history-list",

  initialize: function () {
    this.child_views = [];
  },

  addOne: function (user) {
    let child_view = new App.View.MatchHistoryView();
    this.child_views.push(child_view);
    this.$el.append(child_view.render(user).$el);
  },

  render: function () {
    this.$el.empty();
    let matches_data = [
      {
        match_type: "듀얼전",
        is_win: true,
        score: {
          player: 3,
          enemy: 1,
        },
      },
      {
        match_type: "승급전",
        is_win: false,
        score: {
          player: 1,
          enemy: 3,
        },
      },
    ];
    matches_data.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
