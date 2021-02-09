import * as Draw from "srcs/draw";
import { App } from "srcs/internal";

export const GameScore = Backbone.Model.extend({
  defaults: {},
  initialize: function (cvs, ctx, spec) {
    this.spec = spec;
    this.ctx = ctx;
    this.x = cvs.width / 4;
    this.y = cvs.height / 5;
    this.left = 0;
    this.right = 0;
    this.fillstyle = "WHITE";
    this.font = "60px Brush Script MT";
    this.target_score = spec.target_score;
  },

  isGameEnd: function () {
    return _.max([this.left, this.right]) == this.target_score;
  },

  isWin: function (side) {
    if (!isGameEnd) return;
    return (
      (side == "LEFT" && this.left > this.right) ||
      (side == "RIGHT" && this.right > this.left)
    );
  },

  to_next: function () {
    let next_left =
      this.left + (this.spec.left.id == App.current_user.id ? 0 : 1);
    let next_right =
      this.right + (this.spec.right.id == App.current_user.id ? 0 : 1);
    return {
      type: "SCORE",
      left: next_left,
      right: next_right,
    };
  },

  update: function (data) {
    this.left = +data.left;
    this.right = +data.right;
  },

  // draw left score
  render: function () {
    Draw.drawText(
      this.ctx,
      this.left,
      this.x,
      this.y,
      this.font,
      this.fillstyle
    );

    // draw right score
    Draw.drawText(
      this.ctx,
      this.right,
      3 * this.x,
      this.y,
      this.font,
      this.fillstyle
    );
    return this;
  },
});
