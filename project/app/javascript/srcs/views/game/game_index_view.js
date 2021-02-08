import { App, Helper } from "srcs/internal";

export let GameIndexView = Backbone.View.extend({
  template: _.template($("#game-index-view-template").html()),
  id: "game-index-view",
  className: "flex-container column-direction center-aligned",

  /**
   ** @spec: 게임 참여 플레이어, 룰, 목표 점수 등에 대한 정보
   ** @channel: game_channel
   ** @clear_id: 실행중인 렌더링 엔진을 멈추기 위한 clear key(setInterval)
   */

  initialize: function (id) {
    this.spec = null;
    this.channel = null;
    this.is_player = id == undefined ? true : false;
    this.match_id = id;
    this.left_player_view = null;
    this.right_player_view = null;
    this.play_view = null;
    this.clear_id = null;
  },

  /**
   ** 새로운 래더 게임에 참여, 게임(match) id 변환
   ** render 메서드 실행시 플레이어일 경우 함께 호출
   */
  joinGame: function () {
    Helper.fetch("matches", {
      method: "POST",
      success_callback: this.subscribeChannel.bind(this),
      body: {
        for: "ladder",
        user_id: App.current_user.id,
      },
    });
  },

  /**
   ** 플레이어일 경우 joinMatch의 리턴 데이터를 이용하여 match id를 room으로 지정,
   ** 게스트일 경우 router parameter data를 그대로 room 이름으로 사용
   */
  subscribeChannel: function (data) {
    this.channel = App.Channel.ConnectGameChannel(
      this.recv,
      this,
      this.is_player ? data["match"]["id"] : data
    );
  },

  sendInformation: function (type) {
    Helper.info({
      subject: "게임종료",
      description:
        (type == "END"
          ? "게임이 종료되었습니다. "
          : "유저가 게임을 기권하였습니다. ") +
        "잠시후 홈 화면으로 이동합니다.",
    });
  },

  redirectHomeCallback: function () {
    return App.router.navigate("#/");
  },

  /**
   ** 채널로부터 받은 메시지를 game_index_view로 수신
   ** msg.type에 따라 분기하여 처리
   ** 1) "START" : 게임 시작시 서버에 의해 발송 -> 플레이어 뷰 렌더링
   ** 2) "ENTER" : 게임 중 게스트 입장시 서버에 의해 발송 -> 플레이어 뷰 렌더링
   ** 3) "BROADCAST": 게임 중 공, 패들의 정보를 업데이트 -> 플레이 뷰 업데이트
   ** 4) "END" : 정상적인 게임 종료 -> 클로즈 처리
   ** 5) "ENEMY_GIVEUP" : 게임 중 상대 유저 이탈에 따른 게임 종료 -> 클로즈 처리
   */
  recv: function (msg) {
    if (
      msg.type == "START" ||
      (msg.type == "ENTER" && App.current_user.id == msg["send_id"])
    ) {
      this.spec = msg;
      this.renderPlayerView(msg);
    } else if (msg.type == "BROADCAST") {
      if (this.play_view == null && !this.is_player) {
        this.play_view = new App.View.GamePlayView(this, this.spec);
        this.play_view.update(msg);
        this.start();
      } else this.play_view.update(msg);
    } else if (msg.type == "END" || msg.type == "ENEMY_GIVEUP") {
      if (this.play_view) this.play_view.stopRender();
      if (this.clear_id) clearInterval(this.clear_id);
      this.sendInformation(msg.type);
      setTimeout(this.redirectHomeCallback, 3000);
      this.channel.unsubscribe();
      this.channel = null;
    }
  },

  /**
   ** 플레이어의 경우 카운트다운 후 게임 시작
   ** 게스트일 경우 로딩 대기
   */
  renderPlayerView: function (data) {
    this.left_player_view = new App.View.UserProfileCardView();
    this.right_player_view = new App.View.UserProfileCardView();
    this.$(".vs-icon").html("VS");
    this.$("#left-game-player-view").append(
      this.left_player_view.render(data["left"]).$el
    );
    this.$("#right-game-player-view").append(
      this.right_player_view.render(data["right"]).$el
    );

    if (data.type == "START") {
      this.$(".ui.active.loader").removeClass("active loader");
      this.$("#count-down-box").empty();
      this.countDown();
    }
  },

  /**
   ** 게임 시작시 입장한 플레이어와 게스트는 카운트 다운 후 게임 시작
   ** 게임 중 입장한 게스트일 경우 실행하지 않음
   */
  countDown: function () {
    let $box = this.$("#count-down-box");
    $box.html(10);
    this.clear_id = setInterval(
      function () {
        $box.text(+$box.text() - 1);
        if ($box.text() == 0) {
          clearInterval(this.clear_id);
          this.clear_id = null;
          $box.empty();
          this.start();
        }
      }.bind(this),
      1000
    );
  },

  /**
   ** 게스트의 경우 게임 정보를 동기화하기 위해
   ** 플레이 뷰를 recv에서 먼저 생성하고 게임 정보를 업데이트한 후 시작
   */
  start: function () {
    if (this.play_view == null)
      this.play_view = new App.View.GamePlayView(this, this.spec);
    this.play_view.render();
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());
    if (this.is_player) this.joinGame();
    else this.subscribeChannel(this.match_id);
    return this;
  },

  close: function () {
    if (this.left_player_view) this.left_player_view.close();
    if (this.right_player_view) this.right_player_view.close();
    if (this.play_view) this.play_view.close();
    if (this.channel) this.channel.unsubscribe();
    this.remove();
  },
});
