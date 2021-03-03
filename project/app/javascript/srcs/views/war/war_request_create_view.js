import { App, Helper } from "srcs/internal";

export let WarRequestCreateView = Backbone.View.extend({
  template: _.template($("#war-request-create-view-template").html()),
  id: "war-request-create-view",
  className: "create-view top-margin",

  events: {
    "click .war-request-create-button": "submit",
    "click .war-request-create-cancel-button": "cancel",
  },

  initialize: function () {
    let query = Helper.parseHashQuery();

    this.enemy_guild_id = query.enemy_id;
    this.enemy_guild_name = query.enemy_name;
    this.params = null;
    this.max_date = null;
    this.tomorrow_date = null;
  },

  submit: function () {
    this.params = this.parseWarParams();
    this.params["enemy_guild_id"] = this.enemy_guild_id;
    this.createWar();
  },

  parseWarParams: function () {
    let input_data = {};
    input_data["bet_point"] = +$(".bet-point-input").text();
    input_data["war_start_date"] = $(".war-start-date").val();
    input_data["war_duration"] = +$(".war-duration-input").text();
    input_data["war_time"] = $(".war-time option:selected").val();
    input_data["max_no_reply_count"] = +$(".max-no-reply-count-input").text();
    input_data["rule_id"] = $(".rule option:selected").val();
    input_data["include_ladder"] =
      $('[name="include-ladder"]:checked').val() === undefined ? false : true;
    input_data["include_tournament"] =
      $('[name="include-tournament"]:checked').val() === undefined
        ? false
        : true;
    input_data["target_match_score"] = $(
      '[name="target-match-score"]:checked'
    ).val();
    return input_data;
  },

  createWar: function () {
    const url = `guilds/${App.current_user.get("guild").id}/war_requests`;
    Helper.fetch(url, {
      method: "POST",
      body: this.params,
      success_callback: () => {
        App.router.navigate("#/guilds?page=1");
      },
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    });
  },

  cancel: function () {
    App.router.navigate("#/guilds?page=1");
  },

  setWarStartDateMinAndMax: function () {
    let date = new Date();
    date.setDate(date.getDate() + 1);
    this.min_date = date.toISOString().substring(0, 10);
    date.setDate(date.getDate() + 30);
    this.max_date = date.toISOString().substring(0, 10);
  },

  setRanges: function () {
    $(document).ready(function () {
      function setRange(min, max, class_name, step = 1) {
        $(class_name).range({
          min: min,
          max: max,
          start: min,
          step: step,
          onChange: function (value) {
            $(class_name + "-input").html(value);
          },
        });
      }
      setRange(1000, 10000, ".bet-point", 500);
      setRange(1, 7, ".war-duration");
      setRange(3, 10, ".max-no-reply-count");
    });
  },

  render: function () {
    this.setWarStartDateMinAndMax();
    this.$el.html(
      this.template({
        enemy_guild_name: this.enemy_guild_name,
        min_date: this.min_date,
        max_date: this.max_date,
      })
    );
    this.setRanges();
    return this;
  },

  close: function () {
    this.remove();
  },
});
