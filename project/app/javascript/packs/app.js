$(document).ready(function () {
  let MainView = Backbone.View.extend({
    el: "#temp-view",

    initialize: function () {
      this.current_view = null;
    },

    render: function (main_view) {
      if (this.current_view) this.current_view.close();
      this.current_view = main_view;
      this.$el.html(this.current_view.render().$el);
    },
  });

  let MyLatingView = Backbone.View.extend({});

  let UserRankingView = Backbone.View.extend({});

  let LadderIndexView = Backbone.View.extend({
    template: _.template($("#ladder-index-view-template").html()),
    id: "ladder-index-view",

    initialize: function () {
      // 뷰 생성시 서브뷰도 같이 생성
      this.my_rating_view = new MyLatingView();
      this.user_ranking_view = new UserRankingView();
    },

    render: function () {
      // 템플릿부터 갈아끼우고 서브뷰 렌더
      this.$el.html(this.template);
      this.$("#my-rating-view").html(this.my_rating_view.render().$el);
      this.$("#user-ranking-view").html(this.user_ranking_view.render().$el);
      this.user_ranking_view.render();
      // return this 까먹지 말고 필수로 처리(상위 뷰에서 체이닝 필요)
      return this;
    },

    close: function () {
      // listenTo는 view 삭제시 삭제되므로 누수 방지를 위해 on으로 설정한 event만 off 처리
      this.my_rating_view.remove();
      this.user_ranking_view.remove();
    },
  });

  let mainView = new MainView();
  mainView.render(new LadderIndexView());
});
