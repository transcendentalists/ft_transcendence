import consumer from "./consumer";

export function ConnectGameChannel() {
  return consumer.subscriptions.create("GameChannel", {
    connected() {
      console.log("GAME CONNECT OK");
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      console.log("GAME DISCONNECT OK");
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
    },
  });
}
