// import { NavView } from "./views/nav-view";
// import { fetchContainer, hideModal } from "./helper";
// import { HomeView, SideBarView } from "./internal";
// import { SideBarView } from './views/side-bar-view';
import { App } from "./internal";

export let Router = Backbone.Router.extend({
  routes: {
    "sessions/new": "sessionsController",
    "users(/:param)": "usersController",
    "chatrooms(/:param)": "chatRoomsController",
    "guilds(/:param)": "guildsController",
    "ladder(/:page)": "ladderController",
    "lives(/:matchtype)": "livesController",
    war: "warController",
    "matches/:id": "matchesController",
    "tournaments(/:param)": "tournamenstController",
    "admin(/:param1)(/:param2": "adminController",
    "errors/:id": "errorsController",
  },

  redirect_to: function (viewPrototype, params) {
    if (!App.user.signed_in) return App.entryView.renderSignIn();
    App.mainView.render(viewPrototype, params);
  },

  sessionsController: function () {
    App.entryView.renderSignIn();
  },

  usersController: function (param) {
    if (param === "new") return App.entryView.renderSignUp();
    redirect_to(App.View.UserIndexView, param);
  },

  chatRoomsController: function (param) {
    if (param === null) redirect_to(App.View.ChatIndexView);
    else if (param === "new") redirect_to(App.View.ChatRoomCreateView, params);
    else redirect_to(App.View.ChatRoomView, param);
  },

  guildsController: function (param) {
    if (param === null) redirect_to(App.View.GuildIndexView);
    else if (param === "new") redirect_to(App.View.GuildCreateView, param);
    else redirect_to(App.View.GuildDetailView, param);
  },

  ladderController: function (page = 1) {
    redirect_to(App.view.LadderIndexView, page);
  },

  livesController(matchType = "dual") {
    redirect_to(App.View.LiveIndexView, matchType);
  },

  warController(param) {
    if (param === null) redirect_to(App.View.WarIndexView);
    else if (param === "new") redirect_to(App.View.WarCreateView, param);
    else this.navigate("errors/1");
  },

  matchesController(id) {
    redirect_to(App.View.GameIndexView, id);
  },

  tournamentsController(param) {
    if (param === null) redirect_to(App.View.TournamentIndexView);
    else if (param === "new") redirect_to(App.View.TournamentCreateView, param);
    else this.navigate("errors/2");
  },

  adminController(param1, param2) {
    if (!App.user.signed_in || !App.user.is_admin)
      return this.navigate("errors/3");

    if (param == null) redirect_to(App.View.AdminIndexView);
    else if (param1 === "chatrooms") {
      if (param2 === null) redirect_to(App.View.AdminChatIndexView);
      else redirect_to(App.View.AdminChatRoomView, param2);
    } else if (param1 === "guilds") {
      if (param2 === null) redirect_to(App.View.AdminGuildIndexView);
      else redirect_to(App.View.AdminGuildDetailView, param2);
    } else return this.navigate("errors/4");
  },

  errorsController(id) {
    App.error_view.render(id);
  },
});
