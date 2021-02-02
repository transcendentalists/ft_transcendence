import { App } from "../../../internal";

export let OnlineUserListView = Backbone.View.extend({
  template: _.template($("#appearance-online-user-list-view").html()),

  render: function () {
    this.$el.html(this.template());
    // this.online_user_list = new App.View.OnlineUserListView();
    // 현재 `.me-profile-card` 클래스를 가진 엘리먼트는 DOM 추가되지 않았고, MyRatingView에 존재하므로,
    // setElement 함수내에서 DOM 객체를 참조할 때, this.$() 함수 내에 클래스명을 적어서 참조하였습니다.
    // this.me_profile_card.setElement(this.$(".me-profile-card")).render();
    return this;
  },

  close: function () {
    this.me_profile_card.remove();
  },
});
