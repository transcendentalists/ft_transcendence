// import { NavView } from "./views/nav-view";
// import { fetchContainer, hideModal } from "./helper";
// import { HomeView, SideBarView } from "./internal";
// import { SideBarView } from './views/side-bar-view';
import { App } from "./internal";

export let Router = Backbone.Router.extend({
  routes: {
    "users(/*param)": "usersController",
    home: "homeController",
    "chatrooms(/*param)": "chatRoomsController",
    "guilds(/*param)": "guildsController",
    "ladder(/*param)": "ladderController",
    "lives(/*param)": "livesController",
    war: "warController",
    "matches/:id": "matchesController",
    "tournaments(/*param)": "tournamenstController",
    "admin(/*param)": "adminController",
    "errors/:id": "errorsController",
  },

  usersController(param) {
    App.entry_view.render(param);
  },

  homeController() {
    App.main_view.renderHome();
  },

  chatRoomsController(param) {
    App.main_view.renderChatRooms(param);
  },

  guildsController(param) {
    App.main_view.renderGuilds(param);
  },

  ladderController(param) {
    App.main_view.renderladder(param);
  },

  livesController(param) {
    App.main_view.renderLives(param);
  },

  warController() {
    App.main_view.renderWar();
  },

  matchesController(id) {
    App.main_view.renderMatches(id);
  },

  tournamentsController(param) {
    App.main_view.renderTournaments(param);
  },

  adminController(param) {
    App.main_view.renderAdmin(param);
  },

  errorsController(param) {
    App.main_view.renderError(param);
  },
});
