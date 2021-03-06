import { App } from "srcs/internal";
import * as Draw from "srcs/lib/draw";

export let GamePlayView = Backbone.View.extend({
  el: "ladder-game-section",
  template: _.template(""),

  /**
   ** @spec(object): match_id, left, right, rule, target_score
   ** @is_player(bool): 플레이어인지 게스트인지
   ** @current/enemy_paddle(reference): 플레이어일 경우 자신의 paddle object 참조
   */
  initialize: function (self, spec) {
    this.spec = spec;
    this.parent_view = self;
    this.is_player = self.is_player;
    this.channel = self.channel;
    $("#ladder-game-section").html(
      "<canvas id='game-canvas' width='900' height='400'></canvas>"
    );
    this.cvs = document.getElementById("game-canvas");
    this.ctx = this.cvs.getContext("2d");
    this.net = new App.Model.GameNet(this);
    this.ball = new App.Model.GameBall(this, spec.rule);
    this.score = new App.Model.GameScore(this.cvs, this.ctx, this.spec);
    this.left_paddle = new App.Model.GamePaddle("WHITE", "LEFT", this);
    this.right_paddle = new App.Model.GamePaddle("WHITE", "RIGHT", this);

    if (!self.is_player) return;

    this.current_paddle =
      this.spec.left.id == App.current_user.id
        ? this.left_paddle
        : this.right_paddle;
    this.enemy_paddle =
      this.spec.left.id == App.current_user.id
        ? this.right_paddle
        : this.left_paddle;
    this.clear_key = null;
  },

  /**
   ** @framePerSecond: 초당 통신 횟수
   ** 플레이어일 경우 keydown 이벤트 on(패들 이동 목적),
   ** 초당 통신횟수만큼 renderRoutine을 실행
   */
  render: function () {
    const framePerSecond = 50;
    if (this.is_player) document.onkeydown = this.checkKey.bind(this);
    this.clear_key = setInterval(
      this.renderRoutine.bind(this),
      1000 / framePerSecond
    );
  },

  /**
   ** @p paddle
   ** @b ball
   ** 공이 패들에 부딪혔는지 확인, 벽은 충돌 대상으로 보지 않음
   */
  collision(p, b) {
    b.top = b.y - b.radius;
    b.bottom = b.y + b.radius;
    b.left = b.x - b.radius;
    b.right = b.x + b.radius;

    p.top = p.y;
    p.bottom = p.y + p.height;
    p.left = p.x;
    p.right = p.x + p.width;

    return (
      b.right > p.left &&
      b.bottom > p.top &&
      b.left < p.right &&
      b.top < p.bottom
    );
  },

  /**
   ** channel을 통하여 2가지 객체에 대한 정보를 상황에 따라 발송
   ** 1) ball: 플레이어 패들과 공 충돌시 변화된 공의 정보 발송
   ** 2) score: 플레이어 실점시 서버에 실점 사실을 보고
   */
  operateEngine() {
    this.operateCollision();
    if (this.current_paddle.losePoint(this.ball)) {
      this.operateScore();
    } else if (this.enemy_paddle.near(this.ball)) {
      this.ball.delay_time = 5;
    } else if (this.ball.missPosition()) {
      this.ball.reset();
      this.sendObjectSpec(this.ball.to_simple());
    }
  },

  operateCollision: function () {
    if (this.collision(this.current_paddle, this.ball)) {
      this.current_paddle.hit(this.ball);
      return this.sendObjectSpec(this.ball.to_simple());
    }
  },

  operateScore: function () {
    this.sendObjectSpec(this.score.to_next());
    this.channel.losePoint(
      App.current_user.id,
      this.current_paddle.side.toLowerCase()
    );
    this.ball.reset();
    this.sendObjectSpec(this.ball.to_simple());
  },

  /**
   ** 채널에 객체 정보(공의 위치, 속도 등과 스코어)를 전달
   ** object는 각 모델의 to_simple 메서드를 실행하여 필요한 정보를 추린 hash
   */
  sendObjectSpec: function (object) {
    const message = {
      type: "BROADCAST",
      send_id: App.current_user.id,
      object: object,
    };
    this.channel.speak(message);
  },

  /**
   ** 브라우저 엔진을 이용하여
   ** 게임에 필요한 맵, 네트, 공, 패들, 점수현황을 1회 렌더링
   */
  drawCanvas() {
    Draw.drawMap(
      this.ctx,
      0,
      0,
      this.cvs.width,
      this.cvs.height,
      "#F8D90F",
      "#FF7B89"
    );
    this.net.render();
    this.ball.render();
    this.left_paddle.render();
    this.right_paddle.render();
    this.score.render();
  },

  /**
   ** 플레이어의 상하 화살표키 입력을 감지하고, 입력정보를
   ** 현재 패들의 위치정보를 갱신하는 함수로 전달
   */
  checkKey(e) {
    e = e || window.event;
    if (e.keyCode == 38) {
      this.current_paddle?.moveUp(this);
    } else if (e.keyCode == 40) {
      this.current_paddle?.moveDown(this);
    }
  },

  /**
   ** 1) 전달받은 객체가 없을 때 종료
   ** 2) 전달받은 객체의 타입이 '점수'인 경우 스코어를 업데이트
   ** 3) 전달받은 객체의 타입이 '패들'인 경우 패들 위치를 업데이트
   ** 4) 전달받은 객체의 타입이 '공'인 경우 공의 위치나 속도 등을 업데이트
   */
  update: function (data) {
    if (!data) return;
    if (data.object.type !== "SCORE" && data.send_id == App.current_user.id)
      return;

    const object = data.object;
    switch (object.type) {
      case "SCORE":
        this.score.update(object);
        break;
      case "PADDLE":
        this.updatePaddle(object);
        break;
      case "BALL":
        this.ball.update(object);
        break;
    }
  },

  updatePaddle: function (object) {
    if (this.is_player) this.enemy_paddle.update(object);
    else if (object.side == "LEFT") this.left_paddle.update(object);
    else this.right_paddle.update(object);
  },

  /**
   ** render 함수의 호출로 실행됨
   ** 플레이어든 게스트든 공은 결정된 규칙에 의해 움직이고,
   ** 접속자가 플레이어라면 엔진을 실행시켜 충돌 및 실점을 진행함
   ** 이후 게임의 상황을 캔버스에 렌더링
   */
  renderRoutine: function () {
    this.ball.move();
    if (this.is_player) this.operateEngine();

    this.drawCanvas();
  },

  /**
   ** 키에 걸린 이벤트 제거 및 renderRoutine 반복 해제
   */
  stopRender: function () {
    document.onkeydown = null;
    if (!this.clear_key) return;
    clearInterval(this.clear_key);
    this.clear_key = null;
  },

  /**
   ** 게임에 필요한 모든 객체 제거
   */
  close: function () {
    if (this.clear_key) clearInterval(this.clear_key);
    this.parent_view = null;
    this.channel = null;
    this.net = null;
    this.ball = null;
    this.score = null;
    this.left_paddle = null;
    this.right_paddle = null;
    this.current_paddle = null;
    this.enemy_paddle = null;
    this.clear_key = null;
  },
});
