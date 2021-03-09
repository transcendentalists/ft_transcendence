import * as semantic from "srcs/lib/semantic-min";
import * as sync from "srcs/config/backbone.sync";
import { App, Helper } from "srcs/internal";

$(document).ready(function () {
  _.extend(window, Backbone.Events);
  window.onresize = function () {
    window.trigger("resize");
  };
  App.start();
  window.app = App;
  window.helper = Helper;
  Backbone.history.start();
});
