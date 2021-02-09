import { App } from "srcs/internal";

export let MatchHistoryView = Backbone.View.extend({
  // className: "ui text container",
  id: "match-history-view",
  template: _.template($("#match-history-view-template").html()),

  initialize: function () {},

  // t.bigint "rule_id", null: false
  // t.string "eventable_type"
  // t.bigint "eventable_id"
  // t.string "match_type", null: false
  // t.string "status", default: "pending"
  // t.datetime "start_time"
  // t.integer "target_score", default: 3
  // t.datetime "created_at", precision: 6, null: false
  // t.datetime "updated_at", precision: 6, null: false
  // t.index ["eventable_type", "eventable_id"], name: "index_matches_on_eventable"
  // t.index ["rule_id"], name: "index_matches_on_rule_id"

  render: function (data) {
    this.$el.html(
      this.template({
        match_type: "승급전",
        is_win: true,
        score: {
          winner: 3,
          loser: 1,
        },
      })
    );
    return this;
  },

  close: function () {
    this.$el.close();
    this.remove();
  },
});
