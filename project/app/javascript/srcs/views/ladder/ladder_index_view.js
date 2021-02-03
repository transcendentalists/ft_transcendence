import { App } from "srcs/internal";
import { Helper } from "../../helper";

export let LadderIndexView = Backbone.View.extend({
  template: _.template($("#ladder-index-view-template").html()),
  id: "ladder-index-view",

  initialize: function (page) {
    this.page = page;
  },

  user_ranking_callback: function (data) {
    this.$(".user-ranking.ui.container").append(
      this.user_ranking_view.render(data).$el
    );
  },

  render: function () {
    this.$el.html(this.template());
    this.my_rating_view = new App.View.MyRatingView();
    this.user_ranking_view = new App.View.UserRankingView();

    // App.current_user.fetch();
    Helper.fetchContainer("users/" + App.me.id, {
      body: {
        for: "profile",
      },
    }).then(function (data) {
      this.$(".my-rating.ui.container").append(
        this.my_rating_view.render(data).$el
      );
    });

    // this.$(".my-rating.ui.container").append(
    //   this.my_rating_view.render(App.current_user.to_json).$el
    // );

    // fetch("users?for=ladder_index");

    return this;
  },

  close: function () {
    this.my_rating_view.remove();
    this.user_ranking_view.remove();
    this.page = -1;
  },
});
