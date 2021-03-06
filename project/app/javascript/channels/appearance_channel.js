import consumer from "channels/consumer";
import { App } from "srcs/internal";

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
      App.app_view.appearance_view.updateUserList(user);
    },
  });
}
