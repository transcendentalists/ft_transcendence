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
  },

  render: function () {
    const current_user_guild = App.current_user.get("guild");
    const current_user_guild_in_war = current_user_guild?.in_war;
    this.$el.html(
      this.template({ current_user_guild, current_user_guild_in_war })
    );
    if (current_user_guild && current_user_guild_in_war) {
      Helper.fetch(`guilds/${current_user_guild.id}/wars?for=index`, {
        success_callback: this.joinWarChannelAndRenderWarIndexChildViews.bind(
          this
        ),
        fail_callback: (data) => {
          return App.router.navigate(
            `#/errors/${data.error.code}/${data.error.type}/${data.error.msg}`
          );
        },
      });
    }
    return this;
  },

  joinWarChannelAndRenderWarIndexChildViews: function (data) {
    this.war_id = data.war.id;
    if (App.war_channel == null)
      App.war_channel = App.Channel.ConnectWarChannel(data.war.id);
    this.renderWarIndexChildViews(data);
  },

  renderGuildProfileCardView: function (guild) {
    this.guild_profile_card_view = new App.View.GuildProfileCardView({
      guild: guild,
    });
    this.guild_profile_card_view
      .setElement(this.$(".enemy-guild-profile-view"))
      .render();
  },

  renderWarStatusView: function (war_status) {
    this.war_status_view = new App.View.WarStatusView();
    this.war_status_view
      .setElement(this.$(".war-status-view"))
      .render(war_status);
  },

  renderWarRuleView: function (rule) {
    this.rules_of_war = rule;
    this.war_rule_view = new App.View.WarRuleView();
    this.war_rule_view.setElement(this.$(".war-rule-view")).render(rule);
  },

  renderWarBattleView: function (battle) {
    this.war_battle_view = new App.View.WarBattleView({ parent: this });
    this.war_battle_view.setElement(this.$(".war-battle-view")).render(battle);
  },

  renderWarMatchHistory: function (war_matches) {
    this.war_match_history_list_view = new App.View.WarMatchHistoryListView();
    this.war_match_history_list_view
      .setElement(this.$(".war-match-history-list-view"))
      .render(war_matches);
  },

  renderWarIndexChildViews: function (data) {
    this.renderGuildProfileCardView(data.guild);
    this.renderWarStatusView(data.status);
    this.renderWarRuleView(data.rules_of_war);
    this.renderWarBattleView(data.battle);
    this.renderWarMatchHistory(data.matches);
  },

  close: function () {
    if (this.guild_profile_card_view) this.guild_profile_card_view.close();
    if (this.war_status_view) this.war_status_view.close();
    if (this.war_rule_view) this.war_rule_view.close();
    if (this.war_battle_view) this.war_battle_view.close();
    if (this.war_match_history_list_view)
      this.war_match_history_list_view.close();
    this.remove();
  },
});
