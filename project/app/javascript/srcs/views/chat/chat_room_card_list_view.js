import { App } from "srcs/internal";

export let ChatRoomCardListView = Backbone.View.extend({
  className: "flex-container",

  initialize: function () {
    this.child_views = [];
  },

  addOne: function (room) {
    let child_view = new App.View.ChatRoomCardView();
    this.child_views.push(child_view);
    this.$el.append(child_view.render(room).$el);
  },

  render: function (rooms) {
    this.$el.empty();
    rooms.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
  },
});
