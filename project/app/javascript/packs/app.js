import * as semantic from "srcs/semantic-min";
import { App } from "srcs/internal";

$(document).ready(function () {
  App.initialize();
  window.app = App;
  Backbone.history.start();
});
