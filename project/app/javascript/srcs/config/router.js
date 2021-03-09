import { App } from "srcs/internal";

export let Router = Backbone.Router.extend({
  routes: {
    "": "sessionsController",
    "auth/github/callback": "authController",
    "sessions/new": "sessionsController",
    "users(/:param)": "usersController",
    "chatrooms(/:param)": "chatRoomsController",
    "guilds(/:param)": "guildsController",
    "ladder(/:page)": "ladderController",
    "live(/:live_type)": "liveController",
    "war(/:new)": "warController",
    "matches(/:id)": "matchesController",
    "tournaments(/:param)": "tournamentsController",
    "admin(/:param)": "adminController",
    "errors/:id(/:type)(/:msg)": "errorsController",
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

  guildsController: function (param) {
    if (param === null) {
      this.redirect_to(App.View.GuildIndexView);
    } else if (param === "new")
      this.redirect_to(App.View.GuildCreateView, param);
    else this.redirect_to(App.View.GuildDetailView, param);
  },

  ladderController: function (page = 1) {
    this.redirect_to(App.View.LadderIndexView, page);
  },

  liveController(live_type = "dual") {
    this.redirect_to(App.View.LiveIndexView, live_type);
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

  adminController(param) {
    if (!App.current_user.sign_in || App.current_user.get("position") == "user")
      return this.navigate("#/errors/103");

    this.redirect_to(App.View.AdminIndexView);
  },

  errorsController(error_code, type = "", msg = "") {
    if (error_code === null) this.navigate("errors/" + 100);
    else {
      let error_hash = {
        error_code: error_code,
        type: type,
        msg: msg,
      };
      this.redirect_to(App.View.ErrorView, error_hash);
    }
  },
});
