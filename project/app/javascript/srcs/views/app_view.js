import { AppearenceView } from "./persist/appearance/appearance_view";
import { NavBarView } from "./persist/nav_bar_view";
import { MainView } from "./main_view";
import { InviteView } from "./persist/invite_view";
import { DirectChatView } from "./persist/direct_chat_view";

export let AppView = Backbone.View.extend({
  initialize: function () {
    this.appearence_view = new AppearenceView();
    this.navbar_view = new NavBarView();
    this.main_view = new MainView();
    this.invite_view = new InviteView();
    this.direct_chat_view = new DirectChatView();
  },

  render: function () {
    this.appearence_view.render();
    this.navbar_view.render();
    return this;
  },

  restart: function () {
    this.navbar_view.close();
    this.invite_view.close();
    this.direct_chat_view.close();
  },
});
