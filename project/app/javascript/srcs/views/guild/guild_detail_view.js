import { App, Helper } from "srcs/internal";

export let GuildDetailView = Backbone.View.extend({
  template: _.template($("#guild-detail-view-template").html()),
  id: "guild-detail-view",
  className: "top-margin",

  events: {
    "click #member-page-before-button": "beforePage",
    "click #member-page-next-button": "nextPage",
  },

  initialize: function (page) {
    this.page = page ? +page : 1;
    this.guild_id = this.parseGuildId();
    this.is_last_page = false;
    this.guild_profile_card_view = null;
    this.guild_member_ranking_view = null;
    this.war_history_list_view = null;
    this.current_user_guild_profile_url = `guilds/${this.guild_id}?for=profile`;
    this.guild_member_profile_url = `guilds/${this.guild_id}?for=member_ranking&page=${this.page}`;
    this.war_history_url = `guilds/${this.guild_id}/wars`;
    App.current_user.fetch({ data: { for: "profile" } });
  },

  parseGuildId: function () {
    let url = Backbone.history.getFragment();
    return url.slice(url.indexOf("/") + 1, url.lastIndexOf("/"));
  },

  beforePage: function () {
    if (this.page === 1) return;
    App.router.navigate("#/guilds/" + this.guild_id + "/" + (this.page - 1));
  },

  nextPage: function () {
    if (this.is_last_page === true) return;
    App.router.navigate("#/guilds/" + this.guild_id + "/" + (this.page + 1));
  },

  renderGuildProfileCard: function (data) {
    this.guild_profile_card_view = new App.View.GuildProfileCardView(
      data.guild,
      true
    );
    this.guild_profile_card_view
      .setElement(this.$(".current-user-guild.guild-profile-card"))
      .render();
  },

  renderGuildMemberRanking: function (data) {
    const guild_members = data.guild;
    if (guild_members.length < 10) this.is_last_page = true;
    this.guild_member_ranking_view = new App.View.GuildMemberRankingView(
      this.guild_id
    );
    this.guild_member_ranking_view
      .setElement(this.$(".member-ranking-list"))
      .render(guild_members);
  },

  renderWarHistory: function (data) {
    this.war_history_list_view = new App.View.WarHistoryListView();
    this.war_history_list_view
      .setElement(this.$(".war-history-list"))
      .render(data.wars);
  },

  render: function () {
    this.$el.html(this.template());

    Helper.fetch(this.current_user_guild_profile_url, {
      success_callback: this.renderGuildProfileCard.bind(this),
    });

    Helper.fetch(this.guild_member_profile_url, {
      success_callback: this.renderGuildMemberRanking.bind(this),
    });

    Helper.fetch(this.war_history_url, {
      success_callback: this.renderWarHistory.bind(this),
    });

    return this;
  },

  close: function () {
    if (this.guild_profile_card_view) this.guild_profile_card_view.close();
    if (this.guild_member_ranking_view) this.guild_member_ranking_view.close();
    if (this.war_history_list_view) this.war_history_list_view.close();
    this.remove();
  },
});
