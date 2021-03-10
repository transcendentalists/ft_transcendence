import consumer from "channels/consumer";

export function ConnectGroupChatChannel(
  message_collection,
  room_id,
  room_members
) {
  return consumer.subscriptions.create(
    {
      channel: "GroupChatChannel",
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

      received(message) {
        const member = room_members.get(message.user_id);

        switch (message.type) {
          case "msg":
            message_collection.add(message);
            message_collection.trigger("scroll");
            break;
          case "join":
            room_members.add(message.user);
            break;
          case "restore":
            member.set("position", "member");
            member.trigger("restore", member);
            break;
          case "position":
            member.set("position", message.position);
            break;
          case "mute":
            member.set("mute", message.mute);
            break;
        }
      },

      speak(current_user_message) {
        current_user_message["room_id"] = room_id;
        this.perform("speak", current_user_message);
      },
    }
  );
}
