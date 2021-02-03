import { Helper } from "../../internal";

export let UserProfileCardView = Backbone.View.extend({
  template: _.template($("#user-profile-card-template").html()),
  className: "ui segment profile-card",

  initialize: function () {},

  render: function (data) {
    this.$el.html(this.template(data));
    return this;
  },

  close: function () {
    this.$el.empty();
  },
});
