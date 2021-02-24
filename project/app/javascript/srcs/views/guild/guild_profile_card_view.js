import { App, Helper } from "srcs/internal";

export let GuildProfileCardView = Backbone.View.extend({
  template: _.template($("#guild-profile-card-template").html()),
  className: "ui segment guild-profile-card flex-container center-aligned",

  events: {
    "click .guild-show-button": "showGuild",
    "click .guild-leave-button": "leaveGuild",
    "click .guild-join-button": "joinGuild",
    "click .war-request-create-button": "createWarRequest",
  },

  initialize: function (guild) {
    this.guild = guild;
  },

  showGuild: function () {
    App.router.navigate(`#/guilds/${this.guild.id}`);
  },

  leaveGuild: function () {
    const url = `guilds/${this.guild.id}/memberships/${
      App.current_user.get("guild").membership_id
    }`;
    Helper.fetch(url, {
      method: "DELETE",
      success_callback: () => {
        App.current_user.set("guild", null);
        App.router.navigate("#/guilds/page/1", true);
      },
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    });
  },

  joinGuild: function () {
    const url = `guilds/${this.guild.id}/memberships`;
    Helper.fetch(url, {
      method: "POST",
      body: {
        user: {
          id: App.current_user.id,
        },
        position: "member",
      },
      success_callback: (data) => {
        App.current_user.set("guild", data.guildMembership);
        App.router.navigate("#/guilds/page/1", true);
      },
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    });
  },

  createWarRequest: function () {
    App.router.navigate(`#/guilds/war_request/new?enemy_id=${this.guild.id}`);
  },

  render: function () {
    const current_user_guild_id = App.current_user.get("guild")?.id;
    const current_user_guild_position = App.current_user.get("guild")?.position;
    this.$el.html(
      this.template({
        guild: this.guild,
        current_user_guild_id: current_user_guild_id,
        current_user_guild_position: current_user_guild_position,
      })
    );
    return this;
  },

  close: function () {
    this.remove();
  },
});
