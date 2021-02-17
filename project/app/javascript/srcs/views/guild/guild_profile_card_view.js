import { App, Helper } from "../../internal";

export let GuildProfileCardView = Backbone.View.extend({
  template: _.template($("#guild-profile-card-template").html()),
  className: "ui segment profile-card flex-container center-aligned",

  events: {
    "click #guild-show-button": "showGuild",
    "click #guild-leave-button": "leaveGuild",
    "click #guild-join-button": "joinGuild",
  },

  initialize: function (guild_id) {
    this.guild_id = guild_id;
  },

  showGuild: function () {
    App.router.navigate("#/guilds/" + this.guild_id);
  },

  leaveGuild: function () {
    const leave_guild_url =
      "guilds/" +
      this.guild_id +
      "/memberships/" +
      App.current_user.get("guild").membership_id;
    Helper.fetch(leave_guild_url, {
      method: "DELETE",
      success_callback: function () {
        App.current_user.fetch({
          data: { for: "profile" },
        });
        App.router.navigate(`#/users/${App.current_user.id}`);
      },
      fail_callback: function () {
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
      success_callback: function (data) {
        App.current_user.fetch({
          data: { for: "profile" },
        });
        App.router.navigate(`#/users/${App.current_user.id}`);
      },
      fail_callback: function () {
        Helper.info({
          subject: "가입 실패",
          description: "오류",
        });
      },
    });
  },

  render: function (data) {
    data.current_user_guild_id = App.current_user.getGuildId();
    this.$el.html(this.template(data));
    return this;
  },

  close: function () {
    this.$el.empty();
    this.remove();
  },
});
