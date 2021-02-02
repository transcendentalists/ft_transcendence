import { App, Helper } from "srcs/internal";

export let AppearenceView = Backbone.View.extend({
  el: "#appearance-view",
  template: _.template($("#appearance-view-template").html()),

  events: {
    "click .logout.button ": "logout",
  },

  initialize: function () {
    // this.$el.hide();
    // this.render();
  },

  logout: function () {
    // + undescribe appearance channel
    this.$el.empty();
    Helper.fetchContainer(`users/${App.me.get("id")}/session`, {
      method: "DELETE",
    });
    App.restart();
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());
  },
});
