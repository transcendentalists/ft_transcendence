import consumer from "./consumer";

export function ConnectAppearanceChannel() {
  return consumer.subscriptions.create("AppearanceChannel", {
    connected() {
      console.log("APPERANCE CONNECT OK");
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      console.log("APPERANCE DISCONNECT OK");
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
    },
  });
}
