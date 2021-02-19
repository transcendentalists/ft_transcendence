import { App, Helper } from "srcs/internal";

export let GuildProfileCardView = Backbone.View.extend({
  template: _.template($("#guild-profile-card-template").html()),
  className: "ui segment profile-card flex-container center-aligned",

  events: {
    "click #guild-show-button": "showGuild",
    "click #guild-leave-button": "leaveGuild",
    "click #guild-join-button": "joinGuild",
    "click #war-request-create-button": "createWarRequest",
  },

  initialize: function (guild_id) {
    this.guild_id = guild_id;
  },

  showGuild: function () {
    App.router.navigate(`#/guilds/${this.guild_id}`);
  },

  leaveGuild: function () {
    const url = `guilds/${this.guild_id}/memberships/${App.current_user.get("guild").membership_id}`;
    Helper.fetch(url, {
      method: "DELETE",
      success_callback: () => {
        App.current_user.fetch({
          data: { for: "profile" },
          success: () => {
            App.router.navigate("#/guilds", true);
          },
        });
      },
      fail_callback: () => {
        Helper.info({
          subject: "탈퇴 실패",
          description: "오류",
        });
      },
    });
  },

  joinGuild: function () {
    const url = `guilds/${this.guild_id}/memberships/`;
    Helper.fetch(url, {
      method: "POST",
      body: {
        user: {
          id: App.current_user.id,
        },
        position: "member",
      },
      success_callback: data => {
        App.current_user.fetch({
          data: { for: "profile" },
          success: () => {
            App.router.navigate("#/guilds", true);
          },
        });
      },
      fail_callback: () => {
        Helper.info({
          subject: "가입 실패",
          description: "오류",
        });
      },
    });
  },

  createWarRequest: function () {
    App.router.navigate(`#/guilds/war_request/new?enemy_id=${this.guild_id}`);
  },

  render: function (data) {
    data.current_user_guild_id = App.current_user.getGuildId();
    data.current_user_guild_position = App.current_user.getGuildPosition();
    this.$el.html(this.template(data));
    return this;
  },

  close: function () {
    this.remove();
  },
});
