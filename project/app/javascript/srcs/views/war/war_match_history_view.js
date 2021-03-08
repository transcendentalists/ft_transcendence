import { Helper } from "srcs/helper";

export let WarMatchHistoryView = Backbone.View.extend({
  className: "war-match-history-view flex-container center-aligned",
  template: _.template($("#match-history-view-template").html()),

  initialize: function () {},

  render: function (data) {
    const match_type = data["match"]["match_type"];
    const user_card = data["current_guild_user_scorecard"];
    const enemy_user_card = data["opponent_guild_user_scorecard"];
    const enemy_user = data["opponent_guild_user"];
    this.$el.html(
      this.template({
        match_type,
        user_card,
        enemy_user_card,
        enemy_user,
        win: user_card.result == "win",
      })
    );
    return this;
  },

  close: function () {
    this.remove();
  },
});
