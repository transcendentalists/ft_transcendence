import { Helper } from "../../internal";

export let GuildProfileCardView = Backbone.View.extend({
  template: _.template($("#guild-profile-card-template").html()),
  className: "ui segment profile-card flex-container center-aligned",

  initialize: function () {},

  render: function (data) {
    this.$el.html(this.template(data));
    return this;
  },

  close: function () {
    this.$el.empty();
    this.remove();
  },
});
