import { App, Helper } from "srcs/internal";

export let GuildInvitationView = Backbone.View.extend({
  template: _.template($("#guild-invitation-view-template").html()),
  className: "ui card mobile-only",
  events: {
    "click .approve.button": "approve",
    "click .decline.button": "decline",
  },

  render: function (guild_invitation) {
    this.guild_invitation_id = guild_invitation.id;
    this.guild_id = guild_invitation.guild.id;
    this.$el.html(this.template(guild_invitation));
    return this;
  },

  approve: function () {
    const url = `/guilds/${this.guild_id}/memberships`;
    Helper.fetch(url, {
      method: "POST",
      body: {
        user: {
          id: App.current_user.id,
        },
        position: "member",
      },
      success_callback: (data) => {
        App.current_user.set("guild", data.guild_membership);
        App.router.navigate(`#/users/${App.current_user.id}`, true);
      },
      fail_callback: Helper.defaultErrorHandler,
    });
  },

  decline: function () {
    const url = `users/${App.current_user.id}/guild_invitations/${this.guild_invitation_id}`;
    Helper.fetch(url, {
      method: "DELETE",
      success_callback: () => this.close(),
      fail_callback: Helper.defaultErrorHandler,
    });
  },

  close: function () {
    this.remove();
  },
});
