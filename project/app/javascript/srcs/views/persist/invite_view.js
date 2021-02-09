import { Helper } from "srcs/internal";

export let InviteView = Backbone.View.extend({
  template: _.template($("#invite-view-template").html()),
  el: "#invite-view",

  initialize: function () {
    this.$el.hide();
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());
    this.$el.show();
  },

  close: function () {
    this.$el.hide();
  },
});
