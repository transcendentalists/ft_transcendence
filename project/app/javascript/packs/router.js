// import { NavView } from "./views/nav-view";
// import { fetchContainer, hideModal } from "./helper";
// import { HomeView, SideBarView } from "./internal";
// import { SideBarView } from './views/side-bar-view';
import { App } from "./internal";

let Router = Backbone.Router.extend({
  routes: {
    "": "callHomeView",
    home: "callHomeView",
    ladder: "callLadderView",
  },

  callHomeView: function () {
    this.renderMainView(new HomeView());
  },

  callLadderView: function () {
    if (isLoggedIn()) {
      this.renderMainView(new ChatView());
    } else this.renderModalView(app.signin_view);
  },

  renderMainView: function (view) {
    if (this.currentMainView) {
      this.currentMainView.remove();
    }
    view.render();
    this.currentMainView = view;
    return this;
  },

  renderSideBarView: function (view) {
    view.render();
    this.currentSideBarView = view;
    return this;
  },
});

// function resetSignButton() {
//   $("a[data-sign-value=signin]").removeClass("invisible");
//   $("a[data-sign-value=signup]").removeClass("invisible");
//   $("a[data-sign-value=logout]").addClass("invisible");
// }

export let router = new Router();
