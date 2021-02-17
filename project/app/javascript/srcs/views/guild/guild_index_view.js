import { App, Helper } from "srcs/internal";

export let GuildIndexView = Backbone.View.extend({
  id: "guild-index-view",
  template: _.template($("#guild-index-view-template").html()),

  initialize: function () {
    this.guild = App.current_user.get("guild");
    this.guild_profile_card_view = null;
    this.war_request_card_view = null;
    this.guild_ranking_view = null;
  },

  renderGuildProfileCallback: function (data) {
    this.guild_profile_card_view = new App.View.GuildProfileCardView(
      data.guild.id
    );
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
    data.guilds.my_guild_id = App.current_user.getGuildId();
    this.guild_ranking_view = new App.View.GuildRankingView();
    this.guild_ranking_view
      .setElement(this.$(".guild-ranking-list"))
      .render(data.guilds);
  },

  redirectHomeCallback: function () {
    return App.router.navigate("#/");
  },

  render: function () {
    this.$el.html(this.template({ guild: this.guild }));

    if (this.guild) {
      const guild_profile_url =
        "guilds/" +
        this.guild.id +
        "?for=profile&user_id=" +
        App.current_user.id;
      Helper.fetch(guild_profile_url, {
        success_callback: this.renderGuildProfileCallback.bind(this),
      });

      const war_request_url =
        "guilds/" + this.guild.id + "/war_requests?for=guild_index";
      Helper.fetch(war_request_url, {
        success_callback: this.renderWarRequestCallback.bind(this),
      });
    }

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
