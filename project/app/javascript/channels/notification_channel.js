import consumer from "./consumer";
import { App, Helper } from "srcs/internal";

export function ConnectNotificationChannel() {
  return consumer.subscriptions.create("NotificationChannel", {
    connected() {},

    disconnected() {
      this.unsubscribe();
    },

    received(data) {
      if (data.type == "MatchCreate" && Helper.isCurrentUser(data.enemy_id)) {
        App.appView.invite_view.render(data.profile, data.match_id);
      } else if (
        data.type == "MatchCancel" &&
        Helper.isCurrentUser(data.user_id)
      ) {
        Helper.info({
          subject: "게임 취소",
          description:
            "상대방이 게임 요청을 거절하였습니다. 잠시후 홈 화면으로 이동합니다.",
        });
        setTimeout(this.redirectHomeCallback, 3000);
      }
    },

    redirectHomeCallback: function () {
      return App.router.navigate("#/");
    },
  });
}
