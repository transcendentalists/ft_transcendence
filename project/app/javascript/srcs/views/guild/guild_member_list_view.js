import { App } from "srcs/internal";

export let GuildMemberListView = Backbone.View.extend({
  template: _.template($("#guild-member-list-view-template").html()),

  initialize: function (options) {
    this.child_views = [];
    this.guild_id = options.guild_id;
  },

  addOne: function (member) {
    let guild_member_profile_card_view = new App.View.GuildMemberProfileCardView();
    this.child_views.push(guild_member_profile_card_view);
    this.$el.append(guild_member_profile_card_view.render(member).$el);
  },

  render: function (members) {
    this.$el.html(this.template());
    members.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((guild_member_profile_card_view) =>
      guild_member_profile_card_view.close()
    );
    this.child_views = [];
    this.remove();
  },
});
