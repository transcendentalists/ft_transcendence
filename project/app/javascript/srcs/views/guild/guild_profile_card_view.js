import { App, Helper } from "srcs/internal";

export let GuildProfileCardView = Backbone.View.extend({
  template: _.template($("#guild-profile-card-template").html()),
  className: "ui segment guild-profile-card flex-container center-aligned",

  initialize: function (guild, is_detail_view = false) {
    this.guild = guild;
    this.buttons_view = null;
    this.is_detail_view = is_detail_view;
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
    this.buttons_view = new App.View.GuildProfileCardButtonsView(this.guild);
    this.buttons_view
      .setElement(this.$("#guild-profile-card-buttons-view"))
      .render(this.is_detail_view);
    return this;
  },

  close: function () {
    this.remove();
  },
});
