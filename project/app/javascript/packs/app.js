import * as semantic from "srcs/semantic-min";
import { App } from "srcs/internal";

$(document).ready(function () {
  _.extend(window, Backbone.Events);
  window.onresize = function () {
    window.trigger("resize");
  };
  App.initialize();
  window.aaa = App.current_user; // for debug login trace
  Backbone.history.start();
});
