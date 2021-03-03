import { App, Helper } from "srcs/internal";

export let LadderIndexView = Backbone.View.extend({
  template: _.template($("#ladder-index-view-template").html()),
  id: "ladder-index-view",

  events: {
    "click #ladder-page-before-button": "beforePage",
    "click #ladder-page-next-button": "nextPage",
    "click #join-ladder-button": "joinLadder",
    "click #join-casual-ladder-button": "joinCasualLadder",
  },

  initialize: function (page) {
    this.page = page ? +page : 1;
    this.is_last_page = false;
    this.my_rating_view = null;
    this.user_ranking_view = null;
  },

  beforePage: function () {
    if (this.page === 1) return;
    App.router.navigate("#/ladder/" + (this.page - 1));
  },

  nextPage: function () {
    if (this.is_last_page === true) return;
    App.router.navigate("#/ladder/" + (this.page + 1));
  },

  alert: function () {
    Helper.info({
      subject: "래더 신청 불가능",
      description: "다른 유저와 듀얼 신청 중에는 래더 신청이 불가능합니다.",
    });
  },

  //  승급전 참여 버튼 클릭시 게임 인덱스 뷰로 이동
  joinLadder: function () {
    if (App.current_user.isWorking()) return this.alert();
    App.router.navigate("#/matches?match_type=ladder");
  },

  joinCasualLadder: function () {
    if (App.current_user.isWorking()) return this.alert();
    App.router.navigate("#/matches?match_type=casual_ladder");
  },

  /**
   ** 서버에 현재 유저의 프로필 페이지를 요청하고
   ** 수신한 데이터를 프로필 템플릿으로 렌더링하는 콜백
   */
  renderMyRatingCallback: function (data) {
    this.my_rating_view = new App.View.MyRatingView();
    this.my_rating_view
      .setElement(this.$("#my-rating-view"))
      .render(data["user"]);
  },

  /**
   ** 서버에 래더 인덱스 페이지들을 요청하고 마지막페이지인지 검사
   ** 유저들을 랭킹 순으로 템플릿에 추가한 뒤
   ** 수신한 유저랭킹 프로필 정보들을 렌더링하는 콜백
   */
  renderUserRankingCallback: function (data) {
    this.user_ranking_view = new App.View.UserRankingView();
    if (data.users.length < 10) this.is_last_page = true;
    this.user_ranking_view
      .setElement(this.$("#user-ranking-view"))
      .render(data.users);
  },

  /*
   ** 별도 모델이나 컬렉션을 만들지 않고 처리
   ** 현재 유저와 래더 랭킹 페이지에 필요한 url을 만들어 fetch
   ** 각각 렌더링 콜백을 넘겨주어 렌더링 진행
   */
  render: function () {
    this.$el.html(this.template());
    const current_user_url = "users/" + App.current_user.id + "?for=profile";
    Helper.fetch(current_user_url, {
      success_callback: this.renderMyRatingCallback.bind(this),
    });

    const ladder_users_url = "users/?for=ladder_index&page=" + this.page;
    Helper.fetch(ladder_users_url, {
      success_callback: this.renderUserRankingCallback.bind(this),
    });

    return this;
  },

  close: function () {
    if (this.my_rating_view) this.my_rating_view.close();
    if (this.user_ranking_view) this.user_ranking_view.close();
    this.remove();
  },
});
