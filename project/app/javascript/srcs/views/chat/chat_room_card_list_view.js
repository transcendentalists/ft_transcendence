import { App } from "srcs/internal";

export let ChatRoomCardListView = Backbone.View.extend({
  className: "flex-container",

  initialize: function () {
    this.child_views = [];
  },

  render: function (rooms) {
    this.$el.empty();
    rooms.forEach(this.addOne, this);
    return this;
  },

  addOne: function (room) {
    if (room.current_user.position == "ghost") return;
    let child_view = new App.View.ChatRoomCardView();
    this.child_views.push(child_view);
    this.$el.append(child_view.render(room).$el);
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
  },
});
