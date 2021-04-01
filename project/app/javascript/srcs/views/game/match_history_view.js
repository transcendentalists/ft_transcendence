export let MatchHistoryView = Backbone.View.extend({
  className: "match-history-view flex-container center-aligned",
  template: _.template($("#match-history-view-template").html()),

  initialize: function (user_id) {
    this.user_id = user_id;
  },

  render: function (data) {
    const match_type = data.match.match_type;
    const user_card = data.scorecards.find(
      (card) => this.user_id == card.user_id
    );
    const enemy_user_card = data.scorecards.find(
      (card) => this.user_id != card.user_id
    );
    const enemy_user = data.users.find((user) => user.id != this.user_id);
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
