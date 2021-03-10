import { App } from "srcs/internal";
import consumer from "./consumer";

export function ConnectWarChannel(room_id) {
  return consumer.subscriptions.create(
  {
    channel: "WarChannel",
    room_id: room_id,
  },
  {
    connected() {
    },

    disconnected() {
      this.unsubscribe();
    },

    received(data) {
      if (App.mainView.current_view.id == "war-index-view")
        App.mainView.current_view.war_battle_view.updateView(data);
    },

    battleRequest(data) {
      this.perform("battle_request", {
        war_id: data.war_id,
        user_id: data.user_id,
        guild_id: data.guild_id,
      });
    },
  });
}
