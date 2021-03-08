import * as semantic from "srcs/semantic-min";
import * as range from "srcs/range";
import { App } from "srcs/internal";

$(document).ready(function () {
  _.extend(window, Backbone.Events);
  window.onresize = function () {
    window.trigger("resize");
  };
  App.initialize();
  window.app = App;
  Backbone.history.start();
});
