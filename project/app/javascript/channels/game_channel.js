import consumer from "./consumer";
import Helper from "srcs/helper";

export function ConnectGameChannel(recv_callback, self, match_id) {
  return consumer.subscriptions.create(
    {
      channel: "GameChannel",
      match_id: match_id,
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
        recv_callback.bind(self)(data);
      },

      speak(msg) {
        msg["match_id"] = match_id;
        this.perform("speak", msg);
      },

      losePoint(user_id, side) {
        const msg = {
          match_id: match_id,
          send_id: user_id,
          side: side,
        };
        this.perform("losePoint", msg);
      },
    }
  );
}
