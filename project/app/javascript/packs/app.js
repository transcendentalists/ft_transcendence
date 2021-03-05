import * as semantic from "srcs/semantic-min";
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
