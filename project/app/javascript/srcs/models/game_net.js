import * as Draw from "srcs/draw";

export const GameNet = Backbone.Model.extend({
  defaults: {},

  initialize: function (self) {
    this.cvs = self.cvs;
    this.ctx = self.ctx;
    this.x = this.cvs.width / 2 - 1;
    this.y = 0;
    this.width = 2;
    this.height = 10;
    this.color = "BLACK";
  },

  render: function () {
    for (let i = 0; i <= this.cvs.height; i += 15) {
      Draw.drawRect(
        this.ctx,
        this.x,
        this.y + i,
        this.width,
        this.height,
        this.color
      );
    }
    return this;
  },
});
