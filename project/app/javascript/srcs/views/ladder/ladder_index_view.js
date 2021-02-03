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

    App.current_user.fetch();
    this.$(".my-rating.ui.container").append(
      this.my_rating_view.render(App.current_user.to_json).$el
    );

    Helper.fetch("users", {
      body: {
        for: "profile",
        success_callback: this.user_ranking_callback.bind(this),
      },
    });

    return this;
  },

  close: function () {
    this.my_rating_view.remove();
    this.user_ranking_view.remove();
    this.page = -1;
  },
});
