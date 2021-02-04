import { App } from "../../internal";

//ladder index 안에  my_rating, user_ranking 가 있고 이 각각에 user_profile 카드가 존재한다.

export let MyRatingView = Backbone.View.extend({
  className: "ui text container",
  id: "my-rating-view",
  template: _.template($("#my-rating-view-template").html()),

  render: function () {
    console.log("Render MyRatingView");
    this.$el.html(this.template());
    this.current_user_profile_card = new App.View.UserProfileCardView();
    // 현재 `.current_user-profile-card` 클래스를 가진 엘리먼트는 DOM 추가되지 않았고, MyRatingView에 존재하므로,
    // setElement 함수내에서 DOM 객체를 참조할 때, this.$() 함수 내에 클래스명을 적어서 참조하였습니다.
    this.current_user_profile_card
      .setElement(this.$(".current-user-profile-card"))
      .render();
    return this;
  },

  close: function () {
    this.current_user_profile_card.remove();
  },
});
