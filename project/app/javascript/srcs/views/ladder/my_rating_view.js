import { Helper } from "../../helper";
import { App } from "../../internal";

export let MyRatingView = Backbone.View.extend({
  className: "ui text container",
  id: "my-rating-view",
  template: _.template($("#my-rating-view-template").html()),

  render: function () {
    this.$el.html(this.template());
    this.current_user_profile_card = new App.View.UserProfileCardView();
    this.current_user_profile_card
      .setElement(this.$(".current-user-profile-card"))
      .render();
    return this;
  },
});
// render: function () {
//   let obj = this;
//   this.data = Helper.fetch("/api/guilds/:id/memberships");
//   this.guild = Helper.fetch("/api/guilds/:id")
