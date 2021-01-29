import { App } from "../internal";

//ladder index 안에  my_rating, user_ranking 가 있고 이 각각에 user_profile 카드가 존재한다.

export let MyRatingView = Backbone.View.extend({
  className: "ui text container",
  id: "my-rating-view",
  template: _.template($("#my-rating-view-template").html()),

  render: function () {
    console.log("Render MyRatingView");
    this.$el.html(this.template());
    this.me_profile_card = new App.View.UserProfileCardView();
    this.$(".me-profile-card").append(this.me_profile_card.render().$el);
    return this;
  },

  close: function () {
    this.me_profile_card.remove();
  },
});
