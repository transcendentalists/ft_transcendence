import { App, Helper } from "srcs/internal";

export let GuildProfileCardView = Backbone.View.extend({
  template: _.template($("#guild-profile-card-template").html()),
  className: "ui segment guild-profile-card flex-container center-aligned",

  initialize: function (guild_id) {
    this.guild_id = guild_id;
    this.buttons_view = null;
  },

  render: function (data) {
    data.current_user_guild_id = App.current_user.get("guild")?.id;
    data.current_user_guild_position = App.current_user.get("guild")?.position;
    this.$el.html(this.template(data));
    this.buttons_view = new App.View.GuildProfileCardButtonsView(this.guild_id);
    this.buttons_view
      .setElement(this.$("#guild-profile-card-buttons-view"))
      .render(data);
    return this;
  },

  close: function () {
    this.remove();
  },
});
