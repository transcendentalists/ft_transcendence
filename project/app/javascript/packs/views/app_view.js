import { AppearenceView } from "./active/appearance_view";
import { NavBarView } from "./active/nav_bar_view";
import { MainView } from "./main_view";
import { InviteView } from "./active/invite_view";
import { DirectChatView } from "./active/direct_chat_view";

export let AppView = Backbone.View.extend({
  initialize: function () {
    this.appearence_view = new AppearenceView();
    this.navbar_view = new NavBarView();
    this.main_view = new MainView();
    this.invite_view = new InviteView();
    this.direct_chat_view = new DirectChatView();
  },
});
