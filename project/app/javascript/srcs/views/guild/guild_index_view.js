import { App, Helper } from "srcs/internal";

export let GuildIndexView = Backbone.View.extend({
  id: "guild-index-view",
  template: _.template($("#guild-index-view-template").html()),

  initialize: function () {
    this.guild = App.current_user.attributes.guild;
    this.guild_profile_card_view = null;
    this.war_request_card_view = null;
  },

  renderGuildProfileCallback: function (data) {
    this.guild_profile_card_view = new App.View.GuildProfileCardView();
    this.guild_profile_card_view
      .setElement(this.$(".current-user-guild.profile-card"))
      .render(data);
  },

  renderWarRequestCallback: function (data) {
    window.asdf = data;
    this.war_request_card_view = new App.View.WarRequestCardListView();
    this.war_request_card_view
      .setElement(this.$(".war-request-card-list"))
      .render(data["war_requests"]);
  },

  render: function () {
    this.$el.html(this.template());
    const guild_profile_url = "guilds/" + this.guild.id + "?for=profile";
    Helper.fetch(guild_profile_url, {
      success_callback: this.renderGuildProfileCallback.bind(this),
    });

    // const war_request_url = "guilds/" + this.guild.id + "?for=profile";
    const war_request_url =
      "guilds/" + this.guild.id + "/war_requests?for=guild_index";
    Helper.fetch(war_request_url, {
      success_callback: this.renderWarRequestCallback.bind(this),
    });

    return this;
  },

  close: function () {
    if (this.guild_profile_card_view) this.guild_profile_card_view.close();
    if (this.war_request_card_view) this.war_request_card_view.close();
    this.remove();
  },
});
