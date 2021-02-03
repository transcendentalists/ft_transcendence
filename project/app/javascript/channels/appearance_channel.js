import consumer from "./consumer";

export function ConnectAppearanceChannel() {
  consumer.subscriptions.create("AppearanceChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log("ApperanceChannel connect!!!");
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      console.log(data);
    },
  });
}
