import { App } from "srcs/internal";

export let WarBattleView = Backbone.View.extend({
  template: _.template($("#war-battle-view-template").html()),

  events: {
    "click [data-event-name=request-battle]": "requestBattle",
    "click [data-event-name=watch-battle]": "watchBattle",
    "click [data-event-name=approve-battle]": "approveBattle",
  },

  initialize: function (options) {
    this.parent = options.parent;
    this.interval = null;
    this.countdown = false;
    this.template_data = {};
  },

  render: function (battle) {
    this.battle = battle;
    console.log(battle);
    this.switchTemplate(battle);
    this.$el.html(this.template(this.template_data));
    if (this.countdown) this.renderCountDown(battle.wait_time);
    else if (this.template_data.button_event == "watch-battle")
      this.liveLoading(battle.loading_time);
    return this;
  },

  switchTemplate: function (battle) {
    if (battle.war_time !== battle.current_hour)
      return this.setTemplateData("not_war_time");

    const status = battle.match?.status;
    switch (status) {
      case "progress":
        this.setTemplateData("progress");
        this.battle.loading_time = battle.loading_time;
        break;
      case "pending":
        this.setTemplateData(
          (battle.is_my_guild_request ? "our" : "enemy") + "_guild_request"
        );
        break;
      default:
        this.setTemplateData();
        break;
    }
  },

  setTemplateData: function (situation = "default") {
    const options = this.getTemplateData(situation);

    this.template_data.message =
      options.message || "지금은 전쟁 시간이 <br>아닙니다.";
    this.template_data.button_message = options.button_message || "Battle";
    this.template_data.button = options.button || false;
    this.template_data.button_event = options.button_event || "";
    this.countdown = options.countdown || false;
  },

  getTemplateData: function (situation = "default") {
    let data_hash = {
      progress: {
        message: "현재 진행 중인 전투가<br>있습니다.",
        button_event: "watch-battle",
        button_message: "관전 참여",
        button: true,
      },
      our_guild_request: {
        message: "현재 아군이 전투 준비<br>중에 있습니다.",
      },
      enemy_guild_request: {
        message: "상대 길드에서 전투를<br>요청하고 있습니다.",
        button_event: "approve-battle",
        count_down: true,
        button: true,
      },
      not_war_time: {
        message: "지금은 전쟁 시간이<br>아닙니다.",
        button: false,
      },
      default: {
        message: "상대 길드에 전투를<br>요청하시겠습니까?",
        button_event: "request-battle",
        button: true,
      },
    };
    return data_hash[situation] || data_hash.default;
  },

  renderCountDown: function (wait_time) {
    let $remain_time = this.$(".remain-time");
    let time = 300 - +wait_time;
    let min = parseInt(time / 60);
    let sec = time % 60;
    $remain_time.html("(" + min + "min " + sec + "sec)");
    this.interval = setInterval(
      function () {
        min = parseInt(time / 60);
        sec = time % 60;
        --time;
        $remain_time.html("(" + min + "min " + sec + "sec)");
        if (time < 0) {
          clearInterval(this.interval);
          this.interval = null;
        }
      }.bind(this),
      1000
    );
  },

  liveLoading: function (loading_time = 0) {
    if (loading_time >= 10) return;
    let $button = this.$(".ui.red.basic.button");
    $button.addClass("disabled");
    let $remain_time = this.$(".remain-time");
    let time = 10 - +loading_time;
    let sec = time % 60;
    $remain_time.html("(로딩 중 " + sec + "sec)");
    this.interval = setInterval(
      function () {
        sec = time % 60;
        --time;
        $remain_time.html("(로딩 중 " + sec + "sec)");
        if (time < 0) {
          clearInterval(this.interval);
          this.interval = null;
          $remain_time.empty();
          $button.removeClass("disabled");
        }
      }.bind(this),
      1000
    );
  },

  /**
   ** war_channel에서 생성하는 메시지에 따라 updateView가 render
   */
  updateView: function (data) {
    if (this.interval) clearInterval(this.interval);
    this.interval = null;
    this.updateBattleData(data);
    this.render(this.battle);
  },

  updateBattleData: function (data) {
    switch (data.type) {
      case "request":
        this.battle.match = {
          id: data.match_id,
          status: "pending",
        };
        this.battle.is_my_guild_request =
          data.guild_id == App.current_user.get("guild").id;
        this.battle.wait_time = 0;
        break;
      case "start":
        this.battle.match = {
          id: data.match_id,
          status: "progress",
          loading_time: data.loading_time,
        };
        break;
      case "war_time_start":
        this.battle.current_hour = data.current_hour;
        break;
      case "war_time_end":
        this.battle.current_hour = data.current_hour;
        break;
      case "war_end":
        App.router.navigate(
          //TODO: page쿼리 지우기
          `#/guilds/${App.current_user.get("guild").id}?page=1`
        );
        break;
      default:
        this.battle.match = null;
    }
  },

  requestBattle: function () {
    const war_id = this.parent.war_id;
    const rule_id = this.parent.rules_of_war.rule.id;
    const target_match_score = this.parent.rules_of_war.target_match_score;
    App.router.navigate(
      `#/matches?match_type=war&war_id=${war_id}&rule_id=${rule_id}&target_score=${target_match_score}`
    );
  },

  watchBattle: function (event) {
    if ($(event.target).hasClass("disabled")) return;
    if (event) App.router.navigate(`#/matches/${this.battle.match.id}`);
  },

  approveBattle: function () {
    App.router.navigate(
      `#/matches?match_type=war&match_id=${this.battle.match.id}`
    );
  },

  close: function () {
    if (this.interval) clearInterval(this.interval);
    this.interval = null;
    this.remove();
  },
});
