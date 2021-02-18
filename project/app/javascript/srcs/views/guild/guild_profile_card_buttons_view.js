import { App, Helper } from "srcs/internal";

export let GuildProfileCardButtonsView = Backbone.View.extend({
  template: _.template($("#guild-profile-card-buttons-view-template").html()),

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
    App.router.navigate("#/guilds/" + this.guild_id + "/1");
  },

  leaveGuild: function () {
    const leave_guild_url =
      "guilds/" +
      this.guild_id +
      "/memberships/" +
      App.current_user.get("guild").membership_id;
    Helper.fetch(leave_guild_url, {
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
    const join_guild_url = "guilds/" + this.guild_id + "/memberships";
    Helper.fetch(join_guild_url, {
      method: "POST",
      body: {
        user: {
          id: App.current_user.id,
        },
        position: "member",
      },
      success_callback: (data) => {
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
    App.router.navigate("#/guilds/war_request/new?enemy_id=" + this.guild_id);
  },

  render: function (data) {
    this.$el.html(this.template(data));
    return this;
  },

  close: function () {
    this.remove();
  },
});
