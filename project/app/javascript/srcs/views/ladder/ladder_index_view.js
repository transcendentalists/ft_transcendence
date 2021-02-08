import { App } from "srcs/internal";
import { Helper } from "../../helper";

export let LadderIndexView = Backbone.View.extend({
  template: _.template($("#ladder-index-view-template").html()),
  id: "ladder-index-view",

  events: {
    "click #ladder-page-before-button": "before_page",
    "click #ladder-page-next-button": "next_page",
    "click #ladder-join-button": "game_page",
  },

  initialize: function (page) {
    this.page = page ? +page : 1;
    this.is_last_page = false;
  },

  before_page: function () {
    if (this.page === 1) return;
    App.router.navigate("#/ladder/" + (this.page - 1));
  },

  next_page: function () {
    if (this.is_last_page === true) return;
    App.router.navigate("#/ladder/" + (this.page + 1));
  },

  //  승급전 참여 버튼 클릭시 게임 인덱스 뷰로 이동
  game_page: function () {
    App.router.navigate("#/matches");
  },

  /**
   ** 서버에 현재 유저의 프로필 페이지를 요청하고
   ** 수신한 데이터를 프로필 템플릿으로 렌더링하는 콜백
   */
  my_rating_callback: function (data) {
    this.$(".my-rating.ui.container").append(
      this.my_rating_view.render(data["user"]).$el
    );
  },

  /**
   ** 서버에 래더 인덱스 페이지들을 요청하고 마지막페이지인지 검사
   ** 유저들을 랭킹 순으로 템플릿에 추가한 뒤
   ** 수신한 유저랭킹 프로필 정보들을 렌더링하는 콜백
   */
  user_ranking_callback: function (data) {
    if (data.users.length < 10) this.is_last_page = true;
    this.$(".user-ranking.ui.container").append(
      this.user_ranking_view.render(data.users).$el
    );
  },

  /*
   ** 별도 모델이나 컬렉션을 만들지 않고 처리
   ** 현재 유저와 래더 랭킹 페이지에 필요한 url을 만들어 fetch
   ** 각각 렌더링 콜백을 넘겨주어 렌더링 진행
   */

  render: function () {
    this.$el.html(this.template());
    this.my_rating_view = new App.View.MyRatingView();
    this.user_ranking_view = new App.View.UserRankingView();

    const current_user_url = "users/" + App.current_user.id + "?for=profile";
    Helper.fetch(current_user_url, {
      success_callback: this.my_rating_callback.bind(this),
    });

    const ladder_users_url = "users/?for=ladder_index&page=" + this.page;
    Helper.fetch(ladder_users_url, {
      success_callback: this.user_ranking_callback.bind(this),
    });

    return this;
  },

  close: function () {
    this.my_rating_view.close();
    this.user_ranking_view.close();
    this.remove();
  },
});
