import consumer from "./consumer";
import { App } from "srcs/internal";
import { Helper } from "../srcs/helper";

export function ConnectAppearanceChannel() {
  return consumer.subscriptions.create("AppearanceChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      this.unsubscribe();
      // Called when the subscription has been terminated by the server
    },

    received(user) {
      // Called when there's incoming data on the websocket for this channel
      Helper.checkDualRequestOrInviteAndRemove(user);
      App.appView.appearance_view.updateUserList(user);
    },
  });
}
