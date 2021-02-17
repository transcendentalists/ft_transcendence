import { App } from "../../internal";

export let WarRequestCardListView = Backbone.View.extend({
  className: "ui text container",

  initialize: function () {
    this.child_views = [];
  },

  addOne: function (war_request) {
    let child_view = new App.View.WarRequestCardView({
      war_request_id: war_request.id,
      challenger_guild_id: war_request.challenger.id,
    });
    this.child_views.push(child_view);
    this.$el.append(child_view.render(war_request).$el);
  },

  render: function (war_requests) {
    this.$el.empty();
    war_requests.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
