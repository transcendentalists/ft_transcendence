import { App } from "srcs/internal";

export let AppView = Backbone.View.extend({
  initialize: function () {
    this.appearance_view = new App.View.AppearanceView();
    this.nav_bar_view = new App.View.NavBarView();
    this.main_view = new App.View.MainView();

    this.input_modal_view = new App.View.InputModalView();
    this.alert_modal_view = new App.View.AlertModalView();
    this.info_modal_view = new App.View.InfoModalView();

    this.invite_view = new App.View.InviteView();
    this.direct_chat_view = new App.View.DirectChatView();
  },

  render: function () {
    this.appearance_view.render();
    this.nav_bar_view.render();

    // this.invite_view.render();
    // this.direct_chat_view.render();

    return this;
  },

  restart: function () {
    this.appearance_view.close();
    this.nav_bar_view.close();

    this.input_modal_view.close();
    this.alert_modal_view.close();
    this.info_modal_view.close();

    this.invite_view.close();
    this.direct_chat_view.close();
  },
});
