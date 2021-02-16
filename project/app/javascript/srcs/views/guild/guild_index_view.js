import { App, Helper } from "srcs/internal";

export let GuildIndexView = Backbone.View.extend({
  id: "guild-index-view",
  template: _.template($("#guild-index-view-template").html()),

  initialize: function () {
    this.guild = App.current_user.attributes.guild;
    this.guild_profile_card_view = null;
    this.war_request_card_view = null;
    this.guild_ranking_view = null;
  },

  renderGuildProfileCallback: function (data) {
    data.guild.is_guild_of_current_user = Helper.isGuildOfCurrentUser(
      this.guild.id
    );
    // data.guild.append({
    //   is_guild_of_current_user: Helper.isGuildOfCurrentUser(this.guild.id),
    // });
    this.guild_profile_card_view = new App.View.GuildProfileCardView();
    this.guild_profile_card_view
      .setElement(this.$(".current-user-guild.profile-card"))
      .render(data.guild);
  },

  renderWarRequestCallback: function (data) {
    this.war_request_card_view = new App.View.WarRequestCardListView();
    this.war_request_card_view
      .setElement(this.$(".war-request-card-list"))
      .render(data.war_requests);
  },

  renderGuildRankingCallback: function (data) {
    data.guilds.is_guild_of_current_user = Helper.isGuildOfCurrentUser(
      this.guild.id
    );
    this.guild_ranking_view = new App.View.GuildRankingView();
    this.guild_ranking_view
      .setElement(this.$(".guild-ranking-list"))
      .render(data.guilds);
  },

  render: function () {
    this.$el.html(this.template());
    const guild_profile_url = "guilds/" + this.guild.id + "?for=profile";
    Helper.fetch(guild_profile_url, {
      success_callback: this.renderGuildProfileCallback.bind(this),
    });

    const war_request_url =
      "guilds/" + this.guild.id + "/war_requests?for=guild_index";
    Helper.fetch(war_request_url, {
      success_callback: this.renderWarRequestCallback.bind(this),
    });

    const guild_ranking_url = "guilds?for=guild_index";
    Helper.fetch(guild_ranking_url, {
      success_callback: this.renderGuildRankingCallback.bind(this),
    });

    return this;
  },

  close: function () {
    if (this.guild_profile_card_view) this.guild_profile_card_view.close();
    if (this.war_request_card_view) this.war_request_card_view.close();
    if (this.guild_ranking_view) this.guild_ranking_view.close();
    this.remove();
  },
});
