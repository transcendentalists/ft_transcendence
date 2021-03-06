/**
 ** my_rating_view 혹은 user_ranking_view에 의해
 ** 전달되는 데이터를 렌더링하는 역할로 이벤트 감지 없음
 */

export let UserProfileCardView = Backbone.View.extend({
  template: _.template($("#user-profile-card-template").html()),
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
