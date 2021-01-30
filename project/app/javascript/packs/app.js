import { App } from "./internal";
import { Router } from "./router";
import { AppView } from "./views/app_view";
import { AlertModalView } from "./views/aside/alert_modal_view";
import { InfoModalView } from "./views/aside/info_modal_view";
import { InputModalView } from "./views/aside/input_modal_view";
import { ErrorView } from "./views/aside/error_view";

$(document).ready(function () {
  App.router = new Router();
  App.appView = new AppView();
  App.mainView = App.appView.main_view;
  console.log(App.mainView);
  App.alertModalView = new AlertModalView();
  App.infoModalView = new InfoModalView();
  App.inputModalView = new InputModalView();
  App.errorView = new ErrorView();
  App.user = new App.Model.User();
  Backbone.history.start();
});
