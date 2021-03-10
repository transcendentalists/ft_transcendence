import consumer from "./consumer";

export function ConnectWarChannel(room_id) {
  return consumer.subscriptions.create(
  {
    channel: "WarChannel",
    room_id: room_id,
  },
  {
    connected() {
      console.log("YOU ARE IN WAR_INDEX VIEW");
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
    },
  });
}
