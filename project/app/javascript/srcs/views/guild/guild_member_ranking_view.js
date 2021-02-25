import { App } from "srcs/internal";

export let GuildMemberRankingView = Backbone.View.extend({
  template: _.template($("#guild-member-ranking-view-template").html()),
  id: "guild-member-ranking-view",
  className: "ui text container",

  initialize: function (guild_id) {
    this.child_views = [];
    this.guild_id = guild_id;
  },

  addOne: function (member) {
    let child_view = new App.View.UserProfileCardView();
    this.child_views.push(child_view);
    this.$("#guild-member-profile-card-list").append(
      child_view.render(member, true).$el
    );
  },

  render: function (members) {
    this.$el.html(this.template());
    members.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});