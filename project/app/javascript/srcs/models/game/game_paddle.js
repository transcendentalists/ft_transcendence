import * as Draw from "srcs/lib/draw";

export const GamePaddle = Backbone.Model.extend({
  initialize: function (color, side, self) {
    this.cvs = self.cvs;
    this.ctx = self.ctx;
    this.x = side == "LEFT" ? 0 : this.cvs.width - 10;
    this.y = this.cvs.height / 2 - 100 / 2;
    this.color = color;
    this.width = 10;
    this.height = 100;
    this.side = side;
  },

  near: function (ball) {
    if (
      this.side == "RIGHT" &&
      ball.x + ball.radius > ball.cvs.width - ball.velocityX * 5 &&
      ball.velocityX > 0
    )
      return true;
    if (
      this.side == "LEFT" &&
      ball.x - ball.radius < ball.velocityX * -5 &&
      ball.velocityX < 0
    )
      return true;
    return false;
  },

  losePoint: function (ball) {
    if (this.side == "RIGHT" && ball.x + ball.radius > ball.cvs.width)
      return true;
    if (this.side == "LEFT" && ball.x - ball.radius < 0) return true;
    return false;
  },

  hit: function (ball) {
    let collidePoint = ball.y - (this.y + this.height / 2);
    collidePoint = collidePoint / this.height / 2;

    let angleRad = (collidePoint * Math.PI) / 4;
    let direction = ball.x < ball.cvs.width / 2 ? 1 : -1;
    ball.velocityX = direction * ball.speed * Math.cos(angleRad);
    ball.velocityY = ball.speed * Math.sin(angleRad);
    ball.speed += ball.accel_speed;
    ball.applyEngineSpec("PADDLE");
  },

  moveUp: function (self) {
    this.y = Math.max(this.y - 8, 0 - this.height / 2);
    self.sendObjectSpec(this.to_simple());
  },

  moveDown: function (self) {
    this.y = Math.min(this.y + 8, this.cvs.height - this.height / 2);
    self.sendObjectSpec(this.to_simple());
  },

  to_simple: function () {
    return {
      type: "PADDLE",
      y: this.y,
      side: this.side,
    };
  },

  update: function (data) {
    this.y = +data["y"];
  },

  render: function () {
    Draw.drawRect(
      this.ctx,
      this.x,
      this.y,
      this.width,
      this.height,
      this.color
    );
    return this;
  },
});
