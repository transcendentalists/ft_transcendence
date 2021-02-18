import { App, Helper } from "srcs/internal";

export let GuildIndexView = Backbone.View.extend({
  id: "guild-index-view",
  template: _.template($("#guild-index-view-template").html()),

  events: {
    "click #guild-create-button": "createGuild",
  },

  initialize: function () {
    this.current_user_guild = App.current_user.get("guild");
    this.guild_profile_card_view = null;
    this.war_request_card_list_view = null;
    this.guild_ranking_view = null;
  },

  fetchAndRenderGuildProfileCardView: function () {
    this.fetchAndRender(
      "guilds/" +
        this.current_user_guild.id +
        "?for=profile&user_id=" +
        App.current_user.id,
      this.renderGuildProfileCardView.bind(this)
    );
  },

  renderGuildProfileCardView: function (data) {
    this.guild_profile_card_view = new App.View.GuildProfileCardView(
      data.guild.id
    );
    this.guild_profile_card_view
      .setElement(this.$(".current-user-guild.profile-card"))
      .render(data.guild);
  },

  fetchAndRenderWarRequestCardListView: function () {
    this.fetchAndRender(
      "guilds/" + this.current_user_guild.id + "/war_requests?for=guild_index",
      this.renderWarRequestCardListView.bind(this)
    );
  },

  renderWarRequestCardListView: function (data) {
    this.war_request_card_list_view = new App.View.WarRequestCardListView();
    this.war_request_card_list_view
      .setElement(this.$(".war-request-card-list"))
      .render(data.war_requests);
  },

  fetchAndRenderGuildRankingCardListView: function () {
    this.fetchAndRender(
      "guilds?for=guild_index",
      this.renderGuildRankingCardListView.bind(this)
    );
  },

  renderGuildRankingCardListView: function (data) {
    data.guilds.my_guild_id = App.current_user.getGuildId();
    this.guild_ranking_view = new App.View.GuildRankingView();
    this.guild_ranking_view
      .setElement(this.$(".guild-ranking-list"))
      .render(data.guilds);
  },

  fetchAndRender: function (url, success_callback) {
    Helper.fetch(url, {
      success_callback: success_callback,
    });
  },

  render: function () {
    this.$el.html(
      this.template({ current_user_guild: this.current_user_guild })
    );
    if (this.current_user_guild) {
      this.fetchAndRenderGuildProfileCardView();
      this.fetchAndRenderWarRequestCardListView();
    }
    this.fetchAndRenderGuildRankingCardListView();
    return this;
  },

  createGuild: function () {
    App.router.navigate("#/guilds/new");
  },

  close: function () {
    if (this.guild_profile_card_view) this.guild_profile_card_view.close();
    if (this.war_request_card_list_view)
      this.war_request_card_list_view.close();
    if (this.guild_ranking_view) this.guild_ranking_view.close();
    this.remove();
  },
});
