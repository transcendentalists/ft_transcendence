import { App } from "srcs/internal";
import { Helper } from "../../helper";

export let LadderIndexView = Backbone.View.extend({
  template: _.template($("#ladder-index-view-template").html()),
  id: "ladder-index-view",

  events: {
    "click #ladder-page-before-button": "before_page",
    "click #ladder-page-next-button": "next_page",
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

  my_rating_callback: function (data) {
    this.$(".my-rating.ui.container").append(
      this.my_rating_view.render(data["user"]).$el
    );
  },

  user_ranking_callback: function (data) {
    if (data.users.length < 10) this.is_last_page = true;
    this.$(".user-ranking.ui.container").append(
      this.user_ranking_view.render(data.users).$el
    );
  },

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
