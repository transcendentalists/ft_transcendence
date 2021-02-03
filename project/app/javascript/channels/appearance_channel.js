import consumer from "./consumer";
import { App } from "../srcs/internal";

export function ConnectAppearanceChannel() {
  return consumer.subscriptions.create("AppearanceChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log("AppearanceChannel connect!!!");
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
      console.log("AppearanceChannel disconnect!!!");
    },

    received(user) {
      // Called when there's incoming data on the websocket for this channel
      App.appView.appearance_view.updateUserStatus(user);
    },
  });
}
