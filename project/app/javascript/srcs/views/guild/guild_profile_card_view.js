import { App } from "srcs/internal";

export let GuildProfileCardView = Backbone.View.extend({
  template: _.template($("#guild-profile-card-template").html()),
  className: "ui segment guild-profile-card flex-container center-aligned",

  initialize: function (options) {
    this.guild = options.guild;
    this.buttons_view = null;
  },

  render: function () {
    const current_user_guild_id = App.current_user.get("guild")?.id;
    const current_user_guild_position = App.current_user.get("guild")?.position;
    const guild = this.guild;

    this.$el.html(
      this.template({
        guild,
        current_user_guild_id,
        current_user_guild_position,
      })
    );
    if (!this.isInWarIndex()) this.renderButtons();
    return this;
  },

  isInWarIndex: function () {
    const url = Backbone.history.getFragment().split("?")[0];
    return url == "war";
  },

  renderButtons: function () {
    this.buttons_view = new App.View.GuildProfileCardButtonsView({
      guild: this.guild,
    });
    this.buttons_view
      .setElement(this.$("#guild-profile-card-buttons-view"))
      .render();
  },

  close: function () {
    this.remove();
  },
});
