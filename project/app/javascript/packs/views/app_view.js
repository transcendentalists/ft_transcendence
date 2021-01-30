import { App } from "../internal";

export let AppView = Backbone.View.extend({
  initialize: function () {
    // this.appearence_view = new App.View.ApperenceView();
    // this.navbar_view = new App.View.NavBarView();
    this.main_view = new App.View.MainView();
    // this.invite_view = new App.View.InviteView();
    // this.direct_chat_view = new App.View.DirectChatView();
  },

  close: function () {
    // this.appearence_view.colse();
    // this.navbar_view.close();
    this.main_view.close();
    // this.invite_view.close();
    // this.direct_chat_view.close();
    this.remove();
  },
});
