import { App } from "../../internal";

export let UserRankingView = Backbone.View.extend({
  template: _.template($("#user-ranking-view-template").html()),
  id: "user-ranking-view",
  className: "ui text container",

  initialize: function () {
    // 뷰 생성시 서브뷰도 같이 생성
    this.$el.html(this.template());
    window.userEl = this.$el;
    this.user_collection = new App.Collection.Users();
    this.listenTo(this.user_collection, "add", this.addOne);
    this.listenTo(this.user_collection, "reset", this.addAll);
  },

  addOne: function (user) {
    var view = new App.View.UserProfileCardView({ model: user });
    $("#user-profile-card-list").append(view.render().$el);
  },

  addAll: function () {
    this.$("#user-profile-card-list").html(""); // 먼저 있는걸 지운다. the user profile card list
    this.user_collection.each(this.addOne, this);
  },

  render: function () {
    console.log("UserRankingView");
    this.user_collection.fetch({ reset: true });

    return this;
  },

  close: function () {
    this.user_collection.remove();
  },
});
