import { App, Helper } from "srcs/internal";
import * as Draw from "srcs/draw";

export let GamePlayView = Backbone.View.extend({
  el: "ladder-game-section",
  template: _.template(""),

  /**
   ** @spec: match_id, left, right, rule, target_score
   ** @is_player: true(player) or false(guest)
   ** @current/enemy_paddle: references of left/right paddle for player
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

  operateEngine() {
    if (this.collision(this.current_paddle, this.ball)) {
      this.current_paddle.hit(this.ball);
      return this.sendObjectSpec(this.ball.to_simple());
    }
    if (this.current_paddle.losePoint(this.ball)) {
      this.sendObjectSpec(this.score.to_next());
      this.channel.losePoint(
        App.current_user.id,
        this.current_paddle.side.toLowerCase()
      );
      this.ball.reset();
      this.sendObjectSpec(this.ball.to_simple());
    } else if (this.enemy_paddle.near(this.ball)) {
      this.ball.delay_time = 5;
    }
  },

  sendObjectSpec: function (object) {
    const message = {
      type: "BROADCAST",
      send_id: App.current_user.id,
      object: object,
    };
    this.channel.speak(message);
  },

  /** @gradient-options
   ** default: 7BF2E9/B65EBA
   ** FFCF1B/FF881B, FFCDA5/EE4D5F, CE9FFC/7367F0
   ** E2B0FF/9F44D3, 90F7EC/32CCBC, FDEB71/F8D800
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

  checkKey(e) {
    e = e || window.event;
    if (e.keyCode == 38) {
      this.current_paddle.moveUp(this);
    } else if (e.keyCode == 40) {
      this.current_paddle.moveDown(this);
    }
  },

  update: function (data) {
    if (!data.hasOwnProperty("object")) return;

    if (data.object.type == "SCORE") {
      this.score.update(data.object);
      return;
    }

    if (this.is_player && data.send_id == App.current_user.id) return;

    if (data.object.type == "PADDLE") {
      if (this.is_player) this.enemy_paddle.update(data.object);
      else if (data.object.side == "LEFT") this.left_paddle.update(data.object);
      else this.right_paddle.update(data.object);
    } else if (data.object.type == "BALL") {
      this.ball.delay_time = 0;
      this.ball.update(data.object);
    }
  },

  renderRoutine: function () {
    this.ball.move();
    if (this.is_player) this.operateEngine();

    this.drawCanvas();
  },

  render: function () {
    const framePerSecond = 50;
    if (this.is_player) document.onkeydown = this.checkKey.bind(this);
    this.clear_key = setInterval(
      this.renderRoutine.bind(this),
      1000 / framePerSecond
    );
  },

  stopRender: function () {
    document.onkeydown = null;
    if (!this.clear_key) return;
    clearInterval(this.clear_key);
    this.clear_key = null;
  },

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
