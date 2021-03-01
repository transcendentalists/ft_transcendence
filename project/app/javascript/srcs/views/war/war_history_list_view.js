import { App, Helper } from "srcs/internal";

export let WarHistoryListView = Backbone.View.extend({
  el: ".war-history-list",

  initialize: function () {
    this.child_views = [];
  },

  addOne: function (war_history) {
    let child_view = new App.View.WarHistoryView();
    this.child_views.push(child_view);
    this.$el.append(child_view.render(war_history).$el);
  },

  render: function (war_history_list) {
    if (!war_history_list.length)
      this.$el.html("<span>워 히스토리가 쌓이기를 기다리고 있습니다.</span>");
    else war_history_list.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
