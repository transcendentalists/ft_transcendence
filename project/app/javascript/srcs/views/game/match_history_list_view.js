import { App } from "srcs/internal";

export let MatchHistoryListView = Backbone.View.extend({
  template: _.template($("#match-history-list-view-template").html()),
  id: "match-history-list-view",
  className: "ui container",

  initialize: function () {
    this.child_views = [];
  },

  addOne: function (user) {
    let child_view = new App.View.MatchHistoryView();
    this.child_views.push(child_view);
    this.$el.append(child_view.render(user).$el);
  },

  render: function (matches_data) {
    this.$el.html(this.template());
    matches_data.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views = [];
    this.remove();
  },
});
