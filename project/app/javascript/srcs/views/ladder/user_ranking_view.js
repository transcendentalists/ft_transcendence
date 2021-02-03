import { App } from "../../internal";

export let UserRankingView = Backbone.View.extend({
  template: _.template($("#user-ranking-view-template").html()),
  id: "user-ranking-view",
  className: "ui text container",

  initialize: function () {
    this.$el.html(this.template());
    window.userEl = this.$el;
  },

  addOne: function (user) {
    var view = new App.View.UserProfileCardView(user);
    $("#user-profile-card-list").append(view.render().$el);
  },

  addAll: function (data) {
    this.$("#user-profile-card-list").html(""); // 먼저 있는걸 지운다. the user profile card list
    data.each(this.addOne);
  },

  render: function () {
    console.log("UserRankingView");
    this.user_collection.fetch({ reset: true });

    return this;
  },

  // render: function () {
  //   let obj = this;
  //   this.data = Helper.fetch("/api/guilds/:id/memberships");
  //   this.guild = Helper.fetch("/api/guilds/:id")
  //   this.$el.html(this.template({name: this.data.name, title: this.data.title, guild: {name: this.guild.name, anagram: this.guild.anagram, position: this.guild.position}, tier: this.data.tier, win_count: this.data.win_count, lose_count: this.data.lose_count, achievement: {gold: this.data.achievement.gold, silver: this.data.achievement.silver, bronze: this.data.achievement.bronze}}))
  // },,

  close: function () {
    this.user_collection.remove();
  },
});
