import { App, Helper } from "srcs/internal";

export let GuildRankingView = Backbone.View.extend({
  template: _.template($("#guild-ranking-view-template").html()),
  id: "guild-ranking-view",
  className: "ui text container",

  initialize: function () {
    this.child_views = [];
  },

  addOne: function (guild) {
    let child_view = new App.View.GuildProfileCardView(guild);
    this.child_views.push(child_view);
    this.$("#guild-profile-card-list").append(child_view.render().$el);
  },

  render: function (guilds) {
    if (!guilds.length) {
      this.$el.html("<span>존재하는 길드가 없습니다.</span>");
    } else {
      this.$el.html(this.template());
      guilds.forEach(this.addOne, this);
    }
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
