import { App } from "srcs/internal";

export let WarMatchHistoryListView = Backbone.View.extend({
  initialize: function () {
    this.child_views = [];
  },

  addOne: function (match_history) {
    let war_match_history_view = new App.View.WarMatchHistoryView();
    this.child_views.push(war_match_history_view);
    this.$el.append(war_match_history_view.render(match_history).$el);
  },

  render: function (match_history_list) {
    if (!match_history_list.length)
      this.$el.html("<span>대전기록이 쌓이기를 기다리고 있습니다.</span>");
    else match_history_list.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
