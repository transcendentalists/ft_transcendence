import { Helper } from "srcs/helper";

export let MatchHistoryView = Backbone.View.extend({
  // className: "ui text container",
  className: "match-history-view flex-container center-aligned",
  template: _.template($("#match-history-view-template").html()),

  initialize: function () {},

  render: function (data) {
    const match_type = data["match"]["match_type"];
    const current_user_card = data["scorecards"].find((card) =>
      Helper.isCurrentUser(card.user_id)
    );
    const enemy_user_card = data["scorecards"].find(
      (card) => card.id != current_user_card.id
    );
    const enemy_user = data["users"].find(
      (user) => !Helper.isCurrentUser(user.id)
    );
    this.$el.html(
      this.template({
        match_type,
        current_user_card,
        enemy_user_card,
        enemy_user,
        win: current_user_card.result == "win",
      })
    );
    return this;
  },

  close: function () {
    this.remove();
  },
});
