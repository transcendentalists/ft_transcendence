import * as semantic from "srcs/semantic-min";
import { App } from "srcs/internal";

$(document).ready(function () {
  window.app = App;
  window.app.initialize();
  window.aaa = App.current_user; // for debug login trace
  Backbone.history.start();
});
