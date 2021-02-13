import { App } from "srcs/internal";

export let ChatRoomCardListView = Backbone.View.extend({
  className: "flex-container",

  initialize: function () {
    this.child_views = [];
  },

  addOne: function () {
    for (let i = 0; i < 4; ++i) {
      let child_view = new App.View.ChatRoomCardView();
      this.child_views.push(child_view);
      this.$el.append(child_view.render().$el);
    }
  },

  render: function () {
    this.$el.empty();
    this.addOne();
    // users_data.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views = [];
    this.remove();
  },
});
