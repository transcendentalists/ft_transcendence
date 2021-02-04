import { App, Helper } from "srcs/internal";

export let GameIndexView = Backbone.View.extend({
  // template: _.template($("#game-index-view-template").html()),

  initialize: function (id) {
    if (id == null) {
      Helper.fetch("matches", {
        method: "POST",
        body: {
          user_id: App.current_user.id,
        },
      });
    } else Helper.fetch("matches/" + id);
  },

  render: function () {
    return this;
  },

  close: function () {
    this.remove();
  },
});
