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

  initialize: function (match_id) {
    if (match_id) Helper.authenticateREST(match_id);
    this.spec = null;
    this.channel = null;
    this.is_player = match_id == undefined ? true : false;
    this.left_player_view = null;
    this.right_player_view = null;
    this.is_player_view_rendered = false;
    this.play_view = null;
    this.clear_id = null;

    this.parseMatchQuery(match_id);
  },

  parseMatchQuery: function (match_id) {
    let params = Helper.parseHashQuery();
    let default_hash = {
      challenger_id: null,
      war_id: null,
      rule_id: "1",
      target_score: "3",
      match_id: match_id,
    };

    params = Object.assign({}, default_hash, params);
    this.challenger_id = params.challenger_id;
    this.war_id = params.war_id;
    this.rule_id = params.rule_id;
    this.target_score = params.target_score;
    this.match_id = params.match_id;
    this.match_type = params.match_type;
  },

  /**
   ** 새로운 래더 게임에 참여, 게임(match) id 변환
   ** render 메서드 실행시 플레이어일 경우 함께 호출
   */

  joinGame: function () {
    App.current_user.update_status("playing");
    if (this.match_type == "tournament")
      return this.subscribeGameChannelAndBroadcast(this.match_id);
    Helper.fetch("matches", {
      method: "POST",
      success_callback: this.subscribeGameChannelAndBroadcast.bind(this),
      fail_callback: this.rejectMatchCallback.bind(this),
      body: {
        match_type: this.match_type,
        user_id: App.current_user.id,
        rule_id: this.rule_id,
        target_score: this.target_score,
        match_id: this.match_id,
        war_id: this.war_id,
      },
    });
  },

  /**
   ** 플레이어일 경우 joinMatch의 리턴 데이터를 이용하여 match id를 room으로 지정,
   ** 게스트일 경우 router parameter data를 그대로 room 이름으로 사용
   ** 매치 타입이 dual인 경우 게임 채널을 구독하고  challenger한테 broadcast 한다.
   */
  subscribeGameChannelAndBroadcast: function (data) {
    this.match_id = data.match.id || data;
    this.channel = App.Channel.ConnectGameChannel(
      this.recv,
      this,
      this.match_id
    );
    if (this.match_type == "dual" && this.challenger_id != null) {
      App.notification_channel.dualMatchHasCreated(
        this.challenger_id,
        this.match_id
      );
    } else if (this.match_type == "war" && this.war_id != null) {
      App.war_channel.requestBattle({
        war_id: this.war_id,
        guild_id: App.current_user.get("guild").id,
        match_id: this.match_id,
      });
    }
  },

  showInfoModal: function (type = "END") {
    const info_dict = {
      END: ["게임종료", "게임이 종료되었습니다."],
      ENEMY_GIVEUP: ["게임종료", "유저가 게임을 기권하였습니다."],
      STOP: ["잘못된 접근", "취소/종료되었거나 유효하지 않은 게임입니다."],
      LOADING: [
        "게임 미시작",
        "아직 게임이 시작되지 않았습니다. 잠시 후에 접근해주세요.",
      ],
    };

    Helper.info({
      subject: info_dict[type][0],
      description: info_dict[type][1] + " 홈 화면으로 이동합니다.",
    });
  },

  rejectMatchCallback: function () {
    Helper.info({
      subject: "잘못된 접근",
      description: "잠시후 이전 화면으로 이동합니다.",
    });
    setTimeout(() => Backbone.history.history.back(), 1000);
  },

  redirectHome: function (type) {
    this.showInfoModal(type);
    setTimeout(() => App.router.navigate("#/"), 1000);
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
    switch (msg.type) {
      case "PLAY":
        if (this.spec) return;
        this.spec = msg;
        this.renderPlayerView();
        this.countDown();
        break;
      case "WATCH":
        if (this.spec) return;
        if (this.is_player)
          this.play_view.sendObjectSpec(this.play_view.ball.to_simple());
        if (!Helper.isCurrentUser(msg.send_id)) return;
        this.spec = msg;
        this.renderPlayerView();
        if (!this.play_view) this.start();
        break;
      case "BROADCAST":
        if (!this.spec) return;
        this.play_view.update(msg);
        break;
      case "END":
      case "ENEMY_GIVEUP":
        if (this.play_view) this.play_view.stopRender();
        if (this.clear_id) clearInterval(this.clear_id);
        this.redirectHome(msg.type);
        break;
      case "LOADING":
        if (!this.is_player) this.redirectHome(msg.type);
        break;
      case "STOP":
        this.redirectHome(msg.type);
        break;
    }
  },

  /**
   ** 플레이어의 경우 카운트다운 후 게임 시작
   ** 게스트일 경우 로딩 대기
   */
  renderPlayerView: function () {
    this.left_player_view = new App.View.UserProfileCardView();
    this.right_player_view = new App.View.UserProfileCardView();
    this.$(".vs-icon").html("VS");
    this.$("#left-game-player-view").append(
      this.left_player_view.render(this.spec.left).$el
    );
    this.$("#right-game-player-view").append(
      this.right_player_view.render(this.spec.right).$el
    );
  },

  /**
   ** 게임 시작시 입장한 플레이어와 게스트는 카운트 다운 후 게임 시작
   ** 게임 중 입장한 게스트일 경우 실행하지 않음
   */
  countDown: function () {
    this.$(".ui.active.loader").removeClass("active loader");
    this.$("#count-down-box").empty();

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
    if (this.play_view) return;

    this.play_view = new App.View.GamePlayView(this, this.spec);
    this.play_view.score.update(this.spec.score);
    this.play_view.render();
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());
    if (this.is_player) this.joinGame();
    else this.subscribeGameChannelAndBroadcast(this.match_id);
    return this;
  },

  close: function () {
    if (this.left_player_view) this.left_player_view.close();
    if (this.right_player_view) this.right_player_view.close();
    if (this.play_view) this.play_view.close();
    if (this.channel) this.channel.unsubscribe();
    if (this.clear_id) clearInterval(this.clear_id);
    if (this.is_player) App.current_user.update_status("online");
    this.remove();
  },
});
