import { Helper } from "./helper";
import { App } from "./internal";

export let Router = Backbone.Router.extend({
  routes: {
    "": "sessionsController",
    "auth/github/callback": "authController",
    "sessions/new": "sessionsController",
    "users(/:param)": "usersController",
    "chatrooms(/:param)": "chatRoomsController",
    "guilds(/:param)(/:page)": "guildsController",
    "ladder(/:page)": "ladderController",
    "lives(/:matchtype)": "livesController",
    "war(/:new)": "warController",
    "matches(/:id)": "matchesController",
    "tournaments(/:param)": "tournamentsController",
    "admin(/:param1)(/:param2)": "adminController",
    "errors/:id": "errorsController",
    "*exception": "errorsController",
  },

  authController: function () {
    console.log("github login success!");
  },

  redirect_to: function (viewPrototype, param) {
    if (!App.current_user.sign_in) {
      return this.navigate("#/sessions/new");
    }
    App.mainView.render(viewPrototype, param);
  },

  sessionsController: function () {
    if (App.current_user.sign_in)
      return this.navigate("#/users/" + App.current_user.id);
    else App.mainView.render(App.View.SignInView);
  },

  usersController: function (param) {
    if (param === "new") return App.mainView.render(App.View.SignUpView);
    this.redirect_to(App.View.UserIndexView, param);
  },

  chatRoomsController: function (param) {
    if (param === null) this.redirect_to(App.View.ChatIndexView);
    else if (param === "new")
      this.redirect_to(App.View.ChatRoomCreateView, param);
    else this.redirect_to(App.View.ChatRoomView, param);
  },

  guildsController: function (param, page = 1) {
    if (param === null) this.redirect_to(App.View.GuildIndexView);
    else if (param === "new") this.redirect_to(App.View.GuildCreateView, param);
    else this.redirect_to(App.View.GuildDetailView, page);
  },

  ladderController: function (page = 1) {
    this.redirect_to(App.View.LadderIndexView, page);
  },

  livesController(matchType = "dual") {
    this.redirect_to(App.View.LiveIndexView, matchType);
  },

  warController(param) {
    if (param === null) this.redirect_to(App.View.WarIndexView);
    else if (param === "new") this.redirect_to(App.View.WarCreateView, param);
    else this.navigate("#/errors/101");
  },

  matchesController(id) {
    this.redirect_to(App.View.GameIndexView, id);
  },

  tournamentsController(param) {
    if (param === null) this.redirect_to(App.View.TournamentIndexView);
    else if (param === "new")
      this.redirect_to(App.View.TournamentCreateView, param);
    else this.navigate("#/errors/102");
  },

  adminController(param1, param2) {
    if (!App.user.signed_in || !App.current_user.is_admin)
      return this.navigate("#/errors/103");

    if (param == null) this.redirect_to(App.View.AdminUserIndexView);
    else if (param1 === "chatrooms") {
      if (param2 === null) this.redirect_to(App.View.AdminChatIndexView);
      else this.redirect_to(App.View.AdminChatRoomView, param2);
    } else if (param1 === "guilds") {
      if (param2 === null) this.redirect_to(App.View.AdminGuildIndexView);
      else this.redirect_to(App.View.AdminGuildDetailView, param2);
    } else return this.navigate("#/errors/104");
  },

  errorsController(error_code) {
    if (error_code === null) this.navigate("errors/" + 100);
    else this.redirect_to(App.View.ErrorView, error_code);
  },
});
