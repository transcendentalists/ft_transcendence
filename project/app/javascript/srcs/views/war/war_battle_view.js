import { App, Helper } from "srcs/internal";

export let WarBattleView = Backbone.View.extend({
  template: _.template($("#war-battle-view-template").html()),

  initialize: function () {},

  // 버튼이 비활성화: 전쟁 시간 x
  // 우리팀이 신청중일 때 

  render: function (battle) {
    window.b = battle;
    console.log(battle);
    console.dir(battle);
    // 2. 워타임인데 상대방이 게임 요청한 상태
    // 3. 워타임인데 우리팀아 상대방에게 게임 요청한 상태
    // 4. 워타임인데 네가 상대방에게 게임 요청한 상태 -- 이건 안해도 됨
    // 5. 워타임인데 우리팀이랑 상대방이 게임을 실제로 하고 있는 상태
    // 우리팀이 상대팀한테 게임 신청을 한 경우와 상대팀이 우리길드에게 게임신청을 한경우
      // 차이를 알지 못한다.
    this.template_data = {
      button: true,
      message: "",
      button_message: "Battle",
    }
    if (battle.war_time == battle.current_hour) {
      if (battle.match === null) {
        this.template_data.message = "상대 길드에 전투를 요청하시겠습니까?";
      } else if (battle.match.status == "progress") {
        this.template_data.message = "현재 진행 중인 전투가 있습니다.";
        this.template_data.button_message = "관전 참여";
      } else if (battle.match.status == "pending") {
        if (battle.is_my_guild == true) {            
          this.template_data.message = "현재 아군이 전투 준비중에 있습니다.";
          this.template_data.button = false;
        } else {
          this.template_data.message = "상대 길드에서 전투를 요청하고 있습니다.";
        }
      }
    } else {
      this.template_data.message = "지금은 전쟁 시간이 아닙니다";
      this.template_data.button = false;
    }
    this.$el.html(this.template(this.template_data));
    this.countDown(battle.wait_time);
    // if (this.template_data.button) this.countdown(battle.wait_time);
    return this;
  },

  close: function () {
    if (this.interval) clearInterval(this.interval);
    this.remove();
  },

  countDown: function (wait_time) {
    this.$(".remain-time").empty();

    let $remain_time = this.$(".remain-time");

    let time = 300 - +wait_time;
    let min = parseInt(time / 60);
    let sec = time % 60;
    $remain_time.html("(" + min + "min " + sec + "sec)")
    this.interval = setInterval(
      function () {
        min = parseInt(time / 60);
        sec = time % 60;
        --time;
        $remain_time.html("(" + min + "min " + sec + "sec)")
        if (time < 0) {
          clearInterval(this.interval);
          this.interval = null;
          // $remain_time.empty();
          // this.start();
        }
      }.bind(this),
      1000
    );
  },
});
