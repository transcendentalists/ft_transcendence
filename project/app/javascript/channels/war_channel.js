import { App, Helper } from "srcs/internal";
import consumer from "./consumer";

export function ConnectWarChannel(war_id) {
  return consumer.subscriptions.create(
    {
      channel: "WarChannel",
      war_id: war_id,
    },
    {
      connected() {},

      disconnected() {
        this.unsubscribe();
      },

      received(data) {
        if (data.type === "no_reply" && Helper.isCurrentUser(data.user_id)) {
          Helper.info({
            subject: "상대 길드 미응답",
            description: "상대 길드가 응답하지 않아 배틀에서 승리하셨습니다!",
          });
          App.router.navigate(`#/guilds/${App.current_user.get("guild").id}`);
        } else if (Helper.isCurrentView("war-index-view")) {
          this.updateWarBattleView(data);
        }
      },

      updateWarBattleView(data) {
        App.main_view.current_view.war_battle_view?.updateView(data);
      },

      requestBattle(data) {
        this.perform("request_battle", {
          war_id: data.war_id,
          guild_id: data.guild_id,
          match_id: data.match_id,
        });
      },
    }
  );
}
