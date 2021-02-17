import { App, Helper } from "../../internal";

export let GuildProfileCardView = Backbone.View.extend({
  template: _.template($("#guild-profile-card-template").html()),
  className: "ui segment profile-card flex-container center-aligned",

  events: {
    "click #guild-show-button": "showGuild",
    "click #guild-leave-button": "leaveGuild",
  },

  initialize: function (guild_id) {
    this.guild_id = guild_id;
  },

  showGuild: function () {
    App.router.navigate("#/guilds/" + this.guild_id);
  },

  leaveGuild: function () {
    leave_guild_url =
      "guilds/" + this.guild_id + "/guild_memberships/" + App.current_user.id;
    Helper.fetch(leave_guild_url, {
      method: "DELETE",
      success_callback: function () {
        App.router.navigate("#/");
      },
      fail_callback: function () {
        Helper.info({
          subject: "탈퇴 실패",
          description: "오류",
        });
      },
    });
  },

  render: function (data) {
    data.is_guild_of_current_user = Helper.isGuildOfCurrentUser(this.guild_id);
    this.$el.html(this.template(data));
    return this;
  },

  close: function () {
    this.$el.empty();
    this.remove();
  },
});
