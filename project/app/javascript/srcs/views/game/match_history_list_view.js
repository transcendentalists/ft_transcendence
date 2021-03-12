import { App, Helper } from "srcs/internal";

export let MatchHistoryListView = Backbone.View.extend({
  el: ".match-history-list",

  initialize: function (user_id) {
    this.user_id = user_id;
    this.child_views = [];
  },

  render: function (match_history_list) {
    if (!match_history_list.matches?.length) return;
    this.$el.empty();
    match_history_list.matches.forEach(this.addOne, this);
    return this;
  },

  addOne: function (match_history) {
    let child_view = new App.View.MatchHistoryView(this.user_id);
    this.child_views.push(child_view);
    this.$el.append(child_view.render(match_history).$el);
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
