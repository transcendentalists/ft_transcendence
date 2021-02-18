import { App, Helper } from "srcs/internal";

export let WarHistoryListView = Backbone.View.extend({
  el: ".war-history-list",

  initialize: function (guild_id) {
    this.guild_id = guild_id;
    this.child_views = [];
  },

  addOne: function (war_history) {
    let child_view = new App.View.WarHistoryView(this.guild_id);
    this.child_views.push(child_view);
    this.$el.append(child_view.render(war_history).$el);
  },

  render: function (war_history_list) {
    // if (!war_history_list.hasOwnProperty("wars")) return;
    if (war_history_list.length == 0) return;
    war_history_list.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
