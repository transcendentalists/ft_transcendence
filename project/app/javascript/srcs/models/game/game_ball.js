import * as Draw from "srcs/lib/draw";

export const GameBall = Backbone.Model.extend({
  initialize: function (self, rule) {
    this.parent = self;
    this.cvs = self.cvs;
    this.ctx = self.ctx;
    this.x = this.cvs.width / 2;
    this.y = this.cvs.height / 2;
    this.radius = 10;
    this.speed = 3.5;
    this.accel_speed = 0.3;
    this.velocityX = 3.5;
    this.velocityY = 3.5;
    this.opacity = 1;
    this.color = "WHITE";
    this.event_count = 0;
    this.engine_spec = {
      invisible: rule.invisible,
      dwindle: rule.dwindle,
      bound_wall: rule.bound_wall,
      bound_paddle: rule.bound_paddle,
      accel_wall: rule.accel_wall,
      accel_paddle: rule.accel_paddle,
    };
    this.freeze_time = 0;
    this.delay_time = 0;
    this.accel_time = 0;
  },

  applyAddonBall: function () {
    if (this.engine_spec["invisible"]) {
      this.opacity = _.max([this.opacity - 0.04, 0.1]);
    }
    if (this.engine_spec["dwindle"] && this.event_count % 4 == 0) {
      this.radius = _.max([this.radius - 1, 1]);
    }
  },

  applyAddonBound: function (situation) {
    if (!this.engine_spec["bound_" + situation.toLowerCase()]) return;

    let x = Math.abs(this.velocityX);
    let y = Math.abs(this.velocityY);
    let sum = x ** 2 + y ** 2;
    let small_angle = Math.abs(x - y) < 2;

    if ((small_angle && x > y) || (!small_angle && y > x)) {
      y /= 1.5 + (this.event_count % 3) / 2;
      x = Math.sqrt(sum - y ** 2);
    } else {
      x /= 1.5 + (this.event_count % 3) / 2;
      y = Math.sqrt(sum - x ** 2);
    }

    this.velocityX = x * (this.velocityX >= 0 ? 1 : -1);
    this.velocityY = y * (this.velocityY >= 0 ? 1 : -1);
  },

  applyAddonSpeed: function (situation) {
    if (!this.engine_spec["accel_" + situation.toLowerCase()]) return;
    this.accel_time = 5;
  },

  applyEngineSpec: function (situation) {
    const spec_hash = {
      invisible: this.applyAddonBall,
      dwindle: this.applyAddonBall,
      bound_wall: this.applyAddonBound,
      bound_paddle: this.applyAddonBound,
      accel_wall: this.applyAddonSpeed,
      accel_paddle: this.applyAddonSpeed,
    };

    for (let spec in spec_hash)
      if (this.engine_spec[spec]) spec_hash[spec].call(this, situation);

    this.event_count += 1;
  },

  move: function () {
    if (this.freeze_time > 0) return --this.freeze_time;

    if (this.delay_time > 0) {
      this.y += (this.velocityY / 5) * this.delay_time;
      this.x += (this.velocityX / 5) * this.delay_time;
      --this.delay_time;
    } else {
      this.x += this.velocityX;
      this.y += this.velocityY;
      if (this.accel_time > 0) {
        --this.accel_time;
        this.x += this.velocityX * (this.event_count / 30);
        this.y += this.accel_speed * (this.event_count / 30);
      }
    }

    if (this.y + this.radius > this.cvs.height || this.y - this.radius < 0) {
      this.velocityY = -this.velocityY;
      if (Object.values(this.engine_spec).some((mode) => mode == true))
        this.applyEngineSpec("WALL");
    }
  },

  render: function () {
    Draw.drawCircle(
      this.ctx,
      this.x,
      this.y,
      this.radius,
      this.color,
      this.opacity
    );
    return this;
  },

  to_simple: function () {
    return {
      type: "BALL",
      x: this.x,
      y: this.y,
      velocityX: this.velocityX,
      velocityY: this.velocityY,
      speed: this.speed,
      accel_speed: this.accel_speed,
      radius: this.radius,
      opacity: this.opacity,
      event_count: this.event_count,
      freeze_time: this.freeze_time,
      accel_time: this.accel_time,
    };
  },

  update: function (data) {
    this.x = +data.x;
    this.y = +data.y;
    this.velocityX = +data.velocityX;
    this.velocityY = +data.velocityY;
    this.speed = +data.speed;
    this.accel_speed = +data.accel_speed;
    this.radius = +data.radius;
    this.opacity = +data.opacity;
    this.event_count = +data.event_count;
    this.freeze_time = +data.freeze_time;
    this.accel_time = +data.accel_time;
    this.delay_time = 0;
  },

  missPosition: function () {
    const side = this.parent.current_paddle.side == "RIGHT" ? 1 : -1;
    if (side * this.velocityX < 0) return false;

    const x_distance = this.cvs.width / 2;
    const y_distance = this.cvs.height / 2;

    if (this.x < 0 - x_distance || this.x > this.cvs.width + x_distance)
      return true;
    if (this.y < 0 - y_distance || this.y > this.cvs.height + y_distance)
      return true;

    return false;
  },

  reset: function () {
    this.x = this.cvs.width / 2;
    this.y = this.cvs.height / 2;
    this.velocityX = -this.velocityX;
    this.freeze_time = 60;
    this.delay_time = 0;
  },
});
