import { App, Helper } from "srcs/internal";
import consumer from "./consumer";

export function ConnectWarChannel(room_id) {
  return consumer.subscriptions.create(
    {
      channel: "WarChannel",
      room_id: room_id,
    },
    {
      connected() {},

      disconnected() {
        this.unsubscribe();
      },

      received(data) {
        console.log(data);
        if (App.mainView.current_view.id == "war-index-view") {
          App.mainView.current_view.war_battle_view?.updateView(data);
        } else if (
          data.type == "no_reply" &&
          data.user_id == App.current_user.id
        ) {
          Helper.info({
            subject: "상대 길드 미응답",
            description: "상대 길드가 응답하지 않아 배틀에서 승리하셨습니다!",
          });
          App.router.navigate(
            `#/guilds/${App.current_user.get("guild").id}?page=1`
          );
        }
      },

      battleRequest(data) {
        this.perform("battle_request", {
          war_id: data.war_id,
          guild_id: data.guild_id,
          match_id: data.match_id,
        });
      },
    }
  );
}
