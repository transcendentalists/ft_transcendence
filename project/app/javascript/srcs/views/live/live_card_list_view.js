import { App } from "srcs/internal";

export let LiveCardListView = Backbone.View.extend({
  el: "#live-card-list-view",

  initialize: function () {
    this.child_views = [];
  },

  addOne: function (match) {
    let live_card_view = new App.View.LiveCardView({
      parent: this,
    });
    this.child_views.push(live_card_view);
    this.$el.append(live_card_view.render(match).$el);
  },

  render: function (matches) {
    if (!matches || matches.length == 0) return;
    this.$el.empty();
    matches.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
