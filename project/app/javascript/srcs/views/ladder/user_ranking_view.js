import { App } from "../../internal";

export let UserRankingView = Backbone.View.extend({
  template: _.template($("#user-ranking-view-template").html()),
  id: "user-ranking-view",
  className: "ui text container",

  initialize: function () {
    this.child_views = [];
    this.$el.html(this.template());
  },

  addOne: function (user) {
    let child_view = new App.View.UserProfileCardView();
    this.child_views.push(child_view);
    this.$("#user-profile-card-list").append(child_view.render(user).$el);
  },

  render: function (users_data) {
    console.log(users_data);
    this.$("#user-profile-card-list").html("");
    users_data.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views = [];
    this.remove();
  },
});
