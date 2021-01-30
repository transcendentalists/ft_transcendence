import { App } from "./internal";
import { Router } from "./router";
import { MyRatingView } from "./views/my_rating_view";

$(document).ready(function () {
  App.router = new Router();
  // let AppView = new App.View.AppView();
  // let mainView = new App.View.MainView();
  // let ladderView = new App.View.LadderIndexView();
  // mainView.render(ladderView);
  // let homeView = new App.View.homeIndexView();
  // mainView.render(homeView);
  Backbone.history.start();
  // App.router.navigate("#/guilds");
  App.router.navigate("#/guilds/23");
  App.router.navigate("#/guilds/warrequests/new");
  // App.router.navigate("#/guilds/new");
});
