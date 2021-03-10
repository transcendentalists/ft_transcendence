import { App, Helper } from "srcs/internal";

export let WarIndexView = Backbone.View.extend({
  id: "war-index-view",
  template: _.template($("#war-index-view-template").html()),
  className: "top-margin",

  initialize: function () {
    this.guild_profile_card_view = null;
    this.war_status_view = null;
    this.war_rule_view = null;
    this.war_battle_view = null;
    this.war_match_history_list_view = null;
    this.war_channel = null;
  },

  renderGuildProfileCardView: function (guild) {
    this.guild_profile_card_view = new App.View.GuildProfileCardView({
      guild: guild
    });
    this.guild_profile_card_view
      .setElement(this.$(".opponent-guild-profile-view"))
      .render();
  },

  renderWarStatusView: function (war_status) {
    this.war_status_view = new App.View.WarStatusView();
    this.war_status_view
      .setElement(this.$(".war-status-view"))
      .render(war_status);
  },

  renderWarRuleView: function (rule) {
    this.war_rule_view = new App.View.WarRuleView();
    this.war_rule_view
      .setElement(this.$(".war-rule-view"))
      .render(rule);
  },

  renderWarBattleView: function (battle) {
    this.war_battle_view = new App.View.WarBattleView();
    this.war_battle_view
      .setElement(this.$(".war-battle-view"))
      .render(battle);
  },
  
  renderWarMatchHistory: function (war_matches) {
    this.war_match_history_list_view = new App.View.WarMatchHistoryListView();
    this.war_match_history_list_view
      .setElement(this.$(".war-match-history-list-view"))
      .render(war_matches);
  },

  renderWarIndexChilds: function(data) {
    this.renderGuildProfileCardView(data.guild);
    this.renderWarStatusView(data.status);
    this.renderWarRuleView(data.rules_of_war);
    this.renderWarBattleView(data.battle);
    this.renderWarMatchHistory(data.matches);
  },

  joinWarChannelAndRenderWarIndexChilds: function(data) {
    this.war_channel = App.Channel.ConnectWarChannel(data.war.id);
    this.renderWarIndexChilds(data);
  },

  render: function () {
    const current_user_guild = App.current_user.get("guild");
    const current_user_guild_in_war = current_user_guild?.in_war;
    this.$el.html(
      this.template({ current_user_guild: current_user_guild, current_user_guild_in_war: current_user_guild_in_war })
    );
    if (current_user_guild && current_user_guild_in_war) {
      Helper.fetch(`guilds/${current_user_guild.id}/wars?for=index`, {
        success_callback: this.joinWarChannelAndRenderWarIndexChilds.bind(this),
      });
    }
    return this;
  },

  close: function () {
    if (this.guild_profile_card_view) this.guild_profile_card_view.close();
    if (this.war_status_view) this.war_status_view.close();
    if (this.war_rule_view) this.war_rule_view.close();
    if (this.war_battle_view) this.war_battle_view.close();
    if (this.war_match_history_list_view) this.war_match_history_list_view.close();
    if (this.war_channel) this.war_channel.unsubscribe();
    this.remove();
  },
});
