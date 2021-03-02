import { App } from "srcs/internal";

export let GuildInvitationListView = Backbone.View.extend({
  el: "#guild-invitation-list",

  initialize: function () {
    this.child_views = [];
  },

  addOne: function (guild_invitation) {
    let guild_invitation_view = new App.View.GuildInvitationView();
    this.child_views.push(guild_invitation_view);
    this.$el.append(guild_invitation_view.render(guild_invitation).$el);
  },

  render: function (guild_invitations) {
    if (
      !guild_invitations.hasOwnProperty("guild_invitations") ||
      !guild_invitations["guild_invitations"].length
    )
      return;
    this.$el.empty();
    guild_invitations["guild_invitations"].forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((guild_invitation_view) =>
      guild_invitation_view.close()
    );
    this.child_views = [];
    this.remove();
  },
});
