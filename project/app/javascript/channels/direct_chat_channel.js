import consumer from "channels/consumer";

export function ConnectDirectChatChannel(message_collection, room_id) {
  return consumer.subscriptions.create(
    {
      channel: "DirectChatChannel",
      room_id: room_id,
    },
    {
      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        this.unsubscribe();
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        message_collection.add(data);
        message_collection.trigger("scroll");
      },

      speak(current_user_message) {
        current_user_message.room_id = room_id;
        this.perform("speak", current_user_message);
      },
    }
  );
}
