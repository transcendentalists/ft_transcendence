import { App } from "srcs/internal";

export let Router = Backbone.Router.extend({
  routes: {
    "": "sessionsController",
    "sessions/new": "sessionsController",
    "users(/:param)": "usersController",
    "chatrooms(/:param)": "chatRoomsController",
    "guilds(/:param)": "guildsController",
    "ladder(/:page)": "ladderController",
    "live(/:live_type)": "liveController",
    "war(/:new)": "warController",
    "matches(/:id)": "matchesController",
    "tournaments(/:param)": "tournamentsController",
    admin: "adminController",
    "errors/:id(/:type)(/:msg)": "errorsController",
    "*exception": "errorsController",
  },

  redirect_to: function (viewPrototype, param, menu) {
    if (!App.current_user.sign_in) {
      return this.navigate("#/sessions/new");
    }
    App.app_view.nav_bar_view.changeActiveItem(menu);
    App.main_view.render(viewPrototype, param);
  },

  sessionsController: function () {
    if (App.current_user.sign_in) {
      return this.navigate("#/users/" + App.current_user.id);
    } else App.main_view.render(App.View.SignInView);
  },

  usersController: function (param) {
    if (param === "new") return App.main_view.render(App.View.SignUpView);
    const menu = App.current_user.id == param ? "home" : "ladder";
    this.redirect_to(App.View.UserIndexView, param, menu);
  },

  chatRoomsController: function (param) {
    if (param === null) this.redirect_to(App.View.ChatIndexView, null, "chat");
    else if (param === "new")
      this.redirect_to(App.View.ChatRoomCreateView, param, "chat");
    else this.redirect_to(App.View.ChatRoomView, param, "chat");
  },

  guildsController: function (param) {
    if (param === null) {
      this.redirect_to(App.View.GuildIndexView, null, "guild");
    } else if (param === "new")
      this.redirect_to(App.View.GuildCreateView, param, "guild");
    else this.redirect_to(App.View.GuildDetailView, param, "guild");
  },

  ladderController: function (page = 1) {
    this.redirect_to(App.View.LadderIndexView, page, "ladder");
  },

  liveController(live_type = "dual") {
    this.redirect_to(App.View.LiveIndexView, live_type, "live");
  },

  warController(param) {
    if (param === null) this.redirect_to(App.View.WarIndexView, null, "war");
    else if (param === "new")
      this.redirect_to(App.View.WarCreateView, param, "war");
    else this.navigate("#/errors/101");
  },

  matchesController(id) {
    this.redirect_to(App.View.GameIndexView, id);
  },

  tournamentsController(param) {
    if (param === null)
      this.redirect_to(App.View.TournamentIndexView, null, "tournament");
    else if (param === "new")
      this.redirect_to(App.View.TournamentCreateView, param, "tournament");
    else this.navigate("#/errors/102");
  },

  adminController() {
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
