import { App } from "../../internal";

export let LadderIndexView = Backbone.View.extend({
  template: _.template($("#ladder-index-view-template").html()),
  id: "ladder-index-view",

  render: function () {
    // 템플릿부터 갈아끼우고 서브뷰 렌더
    console.log("Render LadderIndexView");
    this.$el.html(this.template());
    this.my_rating_view = new App.View.MyRatingView();
    this.user_ranking_view = new App.View.UserRankingView();

    this.$(".my-rating.ui.container").append(this.my_rating_view.render().$el);
    this.$(".user-ranking.ui.container").append(
      this.user_ranking_view.render().$el
    );
    // return this 까먹지 말고 필수로 처리(상위 뷰에서 체이닝 필요)
    return this;
  },

  close: function () {
    // listenTo는 view 삭제시 삭제되므로 누수 방지를 위해 on으로 설정한 event만 off 처리
    this.my_rating_view.remove();
    // this.user_ranking_view.remove();
  },
});
