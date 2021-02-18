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
    this.war_history_view = null;
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

  fetchAndRenderGuildProfileCardView: function () {
    this.fetchAndRender(
      "guilds/" + this.guild_id + "?for=profile&user_id=" + App.current_user.id,
      this.renderGuildProfileCardView.bind(this)
    );
  },

  renderGuildProfileCardView: function (data) {
    this.guild_profile_card_view = new App.View.GuildProfileCardView(
      data.guild.id
    );
    data.guild.is_detail_view = true;
    this.guild_profile_card_view
      .setElement(this.$(".guild.profile-card"))
      .render(data.guild);
  },

  fetchAndRenderGuildMemberRankingView: function () {
    this.fetchAndRender(
      "guilds/" + this.guild_id + "?for=guild_detail&page=" + this.page,
      this.renderGuildMemberRankingView.bind(this)
    );
  },

  renderGuildMemberRankingView: function (data) {
    data.guild_members.my_guild_id = App.current_user.getGuildId();
    if (data.guild_members.length < 10) this.is_last_page = true;
    this.guild_member_ranking_view = new App.View.GuildMemberRankingView(
      this.guild_id
    );
    this.guild_member_ranking_view
      .setElement(this.$(".member-ranking-list"))
      .render(data.guild_members);
  },

  fetchAndRenderWarHistoryView: function () {
    this.fetchAndRender(
      "guilds/" + this.guild_id + "/wars",
      this.renderWarHistoryListView.bind(this)
    );
  },

  renderWarHistoryListView: function (data) {
    this.war_history_list_view = new App.View.WarHistoryListView();
    this.war_history_list_view
      .setElement(this.$(".war-history-list"))
      .render(data.wars);
  },

  // renderWarHistory: function () {
  //   this.war_history_view = new App.View.WarHistoryListView(this.user_id);

  //   // api/guilds/:guild_id/wars(.:format)?recent=:count&status=:status

  //   // api/wars#index -> query
  //   // api/guilds/:id/wars?recent=:count&status=:status

  //   const war_history_url =
  //     "guilds/" + this.guild_id + "/wars?recent=4&status=completed";

  //   Helper.fetch(war_history_url, {
  //     success_callback: function (war_history_list) {
  //       this.war_history_view
  //         .setElement(this.$(".war-history-list-view"))
  //         .render(war_history_list);
  //     }.bind(this),
  //   });
  // },

  fetchAndRender: function (url, success_callback) {
    Helper.fetch(url, {
      success_callback: success_callback,
    });
  },

  render: function () {
    this.$el.html(this.template());

    this.fetchAndRenderGuildProfileCardView();
    this.fetchAndRenderGuildMemberRankingView();
    this.fetchAndRenderWarHistoryView();

    // const guild_member_profile_url =
    //   "guilds/" + this.guild_id + "/guild_memberships?for=profile";
    // Helper.fetch(guild_member_profile_url, {
    //   success_callback: this.renderMyRatingCallback.bind(this),
    // });

    // const war_history_url = "users/?for=ladder_index&page=" + this.page;
    // Helper.fetch(war_history_url, {
    //   success_callback: this.renderUserRankingCallback.bind(this),
    // });

    return this;
  },

  close: function () {
    if (this.guild_profile_card_view) this.guild_profile_card_view.close();
    this.remove();
  },
});
