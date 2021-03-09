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
        const type = message.type;
        if (type == "msg") {
          message_collection.add(message);
          message_collection.trigger("scroll");
          return;
        }

        const member = room_members.get(message.user_id);
        if (type == "join") {
          room_members.add(message.user);
        } else if (type == "restore") {
          member.set("position", "member");
          member.trigger("restore", member);
        } else if (type == "position") {
          member.set("position", message.position);
        } else if (message.type == "mute") {
          member.set("mute", message.mute);
        }
      },

      speak(current_user_message) {
        current_user_message["room_id"] = room_id;
        this.perform("speak", current_user_message);
      },
    }
  );
}
