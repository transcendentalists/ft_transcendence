import { App } from "srcs/internal";

export let MatchHistoryListView = Backbone.View.extend({
  el: ".match-history-list",

  initialize: function () {
    this.child_views = [];
  },

  addOne: function (match_history) {
    let child_view = new App.View.MatchHistoryView();
    this.child_views.push(child_view);
    this.$el.append(child_view.render(match_history).$el);
  },

  render: function (match_history_list) {
    console.log(
      "🚀 ~ file: match_history_list_view.js ~ line 17 ~ match_history_list",
      match_history_list
    );
    if (!match_history_list.hasOwnProperty("matches")) return;
    this.$el.empty();
    match_history_list["matches"].forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
