import { App } from "srcs/internal";

export let GuildMemberListView = Backbone.View.extend({
  template: _.template($("#guild-member-list-view-template").html()),

  initialize: function (guild_id) {
    this.child_views = [];
    this.guild_member_profile_card_views = [];
    this.guild_id = guild_id;
  },

  addOne: function (member) {
    let guild_member_profile_card_view = new App.View.GuildMemberProfileCardView();
    this.guild_member_profile_card_views.push(guild_member_profile_card_view);
    this.$("#guild-member-profile-card-list").append(
      guild_member_profile_card_view.render(member).$el
    );
  },

  render: function (members) {
    this.$el.html(this.template());
    members.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.guild_member_profile_card_views.forEach((guild_member_profile_card_view) => guild_member_profile_card_view.close());
    this.guild_member_profile_card_views = [];
    this.remove();
  },
});
