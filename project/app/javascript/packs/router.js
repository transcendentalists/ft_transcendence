// import { NavView } from "./views/nav-view";
// import { fetchContainer, hideModal } from "./helper";
// import { HomeView, SideBarView } from "./internal";
// import { SideBarView } from './views/side-bar-view';
import { App } from "./internal";

export let Router = Backbone.Router.extend({
  routes: {
    "users(/:param1)(/:param2)": "usersController",
    home: "homeController",
    "chatrooms(/:param)": "chatRoomsController",
    "guilds(/:param1)(/:param2)": "guildsController",
    "ladder(/:page)": "ladderController",
    "lives(/:matchtype)": "livesController",
    war: "warController",
    "matches/:id": "matchesController",
    "tournaments(/:param)": "tournamenstController",
    "admin(/:param)": "adminController",
    "errors/:id": "errorsController",
  },

  // usersController(params) {
  //   App.entry_view.render(params);
  // },

  // homeController() {
  //   App.main_view.renderHome();
  // },

  // chatRoomsController(params) {
  //   App.main_view.renderChatRooms(params);
  // },

  guildsController(param1, param2) {
    console.log("PARAM 1");
    console.log(param1);
    console.log("PARAM 2");
    console.log(param2);
    // App.main_view.renderGuilds(params);
  },

  // ladderController(params) {
  //   App.main_view.renderladder(params);
  // },

  // livesController(params) {
  //   App.main_view.renderLives(params);
  // },

  // warController() {
  //   App.main_view.renderWar();
  // },

  // matchesController(id) {
  //   App.main_view.renderMatches(id);
  // },

  // tournamentsController(params) {
  //   App.main_view.renderTournaments(params);
  // },

  // adminController(params) {
  //   App.main_view.renderAdmin(params);
  // },

  // errorsController(params) {
  //   App.main_view.renderError(params);
  // },
});
