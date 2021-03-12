import { App, Helper } from "srcs/internal";

export let GuildDetailView = Backbone.View.extend({
  template: _.template($("#guild-detail-view-template").html()),
  warning_message_template: _.template($("#warning-message-template").html()),
  id: "guild-detail-view",
  className: "top-margin",

  events: {
    "click #member-page-before-button": "beforePage",
    "click #member-page-next-button": "nextPage",
  },

  initialize: function (guild_id) {
    const query = Helper.parseHashQuery();
    Helper.authenticateREST(query.page);
    this.page = +query.page;

    this.guild_id = guild_id;
    this.is_last_page = false;
    this.guild_profile_card_view = null;
    this.guild_member_list_view = null;
    this.war_history_list_view = null;
    this.current_user_guild_profile_url = `guilds/${this.guild_id}?for=profile`;
    this.guild_members_profile_url = `guilds/${this.guild_id}/memberships?for=member_list&page=${this.page}`;
    this.war_history_url = `guilds/${this.guild_id}/wars`;
    App.current_user.fetch({ data: { for: "profile" } });
  },

  render: function () {
    this.$el.html(this.template());

    Helper.fetch(this.current_user_guild_profile_url, {
      success_callback: this.renderGuildProfileCard.bind(this),
    });

    Helper.fetch(this.guild_members_profile_url, {
      success_callback: this.renderGuildMemberList.bind(this),
    });

    Helper.fetch(this.war_history_url, {
      success_callback: this.renderWarHistory.bind(this),
      fail_callback: this.renderWarHistoryFailCallback.bind(this),
    });

    return this;
  },

  renderGuildMemberList: function (data) {
    const guild_memberships = data.guild_memberships;
    if (guild_memberships.length < 10) this.is_last_page = true;
    this.guild_member_list_view = new App.View.GuildMemberListView({
      guild_id: this.guild_id,
    });
    this.guild_member_list_view
      .setElement(this.$(".member-list"))
      .render(guild_memberships);
  },

  renderWarHistory: function (data) {
    this.war_history_list_view = new App.View.WarHistoryListView();
    this.war_history_list_view
      .setElement(this.$(".war-history-list"))
      .render(data.wars);
  },

  renderWarHistoryFailCallback: function (data) {
    this.$(".ui.negative.message").empty();
    this.$(".ui.negative.message").append(
      this.warning_message_template(data.error)
    );
    this.$(".ui.negative.message").show();
  },

  renderGuildProfileCard: function (data) {
    this.guild_profile_card_view = new App.View.GuildProfileCardView({
      guild: data.guild,
    });
    this.guild_profile_card_view
      .setElement(this.$(".current-user-guild.guild-profile-card"))
      .render();
  },

  beforePage: function () {
    if (this.page === 1 || this.page === NaN) return;
    App.router.navigate(`#/guilds/${this.guild_id}?page=${this.page - 1}`);
  },

  nextPage: function () {
    if (this.is_last_page === true || this.page === NaN) return;
    App.router.navigate(`#/guilds/${this.guild_id}?page=${this.page + 1}`);
  },

  close: function () {
    if (this.guild_profile_card_view) this.guild_profile_card_view.close();
    if (this.guild_member_list_view) this.guild_member_list_view.close();
    if (this.war_history_list_view) this.war_history_list_view.close();
    this.remove();
  },
});
