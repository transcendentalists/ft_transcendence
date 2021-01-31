import * as semantic from "srcs/semantic-min";
import { App } from "srcs/internal";
import { Router } from "srcs/router";
import { AppView } from "srcs/views/app_view";
import { AlertModalView } from "srcs/views/aside/alert_modal_view";
import { InfoModalView } from "srcs/views/aside/info_modal_view";
import { InputModalView } from "srcs/views/aside/input_modal_view";
import { ErrorView } from "srcs/views/aside/error_view";

$(document).ready(function () {
  App.router = new Router();
  App.appView = new AppView();
  App.mainView = App.appView.main_view;
  App.alertModalView = new AlertModalView();
  App.infoModalView = new InfoModalView();
  App.inputModalView = new InputModalView();
  App.errorView = new ErrorView();
  App.user = new App.Model.User();
  Backbone.history.start();
});
