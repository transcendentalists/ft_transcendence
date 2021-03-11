import * as semantic from "srcs/semantic-min";
import * as range from "srcs/range";
import * as sync from "srcs/backbone.sync";
import { App, Helper } from "srcs/internal";

$(document).ready(function () {
  _.extend(window, Backbone.Events);
  window.onresize = function () {
    window.trigger("resize");
  };
  App.initialize();
  window.app = App;
  window.helper = Helper;
  Backbone.history.start();
});
