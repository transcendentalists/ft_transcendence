import { App, Helper } from "srcs/internal";

export let GuildProfileCardButtonsView = Backbone.View.extend({
  template: _.template($("#guild-profile-card-buttons-view-template").html()),

  events: {
    "click .guild-show-button": "showGuild",
    "click .guild-leave-button": "leaveGuild",
    "click .guild-join-button": "joinGuild",
    "click .war-request-create-button": "createWarRequest",
  },

  initialize: function (options) {
    this.guild = options.guild;
  },

  render: function () {
    const current_user_guild_id = App.current_user.get("guild")?.id;
    const current_user_guild_position = App.current_user.get("guild")?.position;
    const guild = this.guild;
    const guild_show_button = this.isInGuildIndex();

    this.$el.html(
      this.template({
        guild,
        current_user_guild_id,
        current_user_guild_position,
        guild_show_button,
      })
    );

    return this;
  },

  isInGuildIndex: function () {
    const url = Backbone.history.getFragment().split("?")[0];
    return url == "guilds";
  },

  showGuild: function () {
    App.router.navigate(`#/guilds/${this.guild.id}`);
  },

  leaveGuild: function () {
    const leave_guild_url = `guilds/${this.guild.id}/memberships/${
      App.current_user.get("guild").membership_id
    }`;

    Helper.fetch(leave_guild_url, {
      method: "DELETE",
      success_callback: () => {
        App.current_user.set("guild", null);
        App.router.navigate("#/guilds?page=1", true);
      },
      fail_callback: Helper.defaultErrorHandler,
    });
  },

  joinGuild: function () {
    const join_guild_url = `guilds/${this.guild.id}/memberships`;
    Helper.fetch(join_guild_url, {
      method: "POST",
      body: {
        user: {
          id: App.current_user.id,
        },
        position: "member",
      },
      success_callback: (data) => {
        App.current_user.set("guild", data.guild_membership);
        App.router.navigate(
          `#/guilds/${App.current_user.get("guild").id}?page=1`,
          true
        );
      },
      fail_callback: Helper.defaultErrorHandler,
    });
  },

  createWarRequest: function () {
    App.router.navigate(`#/guilds/war_request/new?enemy_id=${this.guild.id}`);
  },

  close: function () {
    this.remove();
  },
});
