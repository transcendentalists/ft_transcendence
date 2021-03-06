import { App } from "srcs/internal";

export let WarRequestCardListView = Backbone.View.extend({
  className: "ui text container",

  initialize: function () {
    this.child_views = [];
  },

  addOne: function (war_request) {
    let child_view = new App.View.WarRequestCardView({
      war_request: war_request
    });
    this.child_views.push(child_view);
    this.$el.append(child_view.render().$el);
  },

  render: function (war_requests) {
    if (!war_requests.length)
      this.$el.html("<span>제안받은 전쟁이 없습니다.</span>");
    war_requests.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
