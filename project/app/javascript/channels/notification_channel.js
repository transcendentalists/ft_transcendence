import consumer from "./consumer";
import { App, Helper } from "srcs/internal";

export function ConnectNotificationChannel(room_id) {
  return consumer.subscriptions.create(
    {
      channel: "NotificationChannel",
      room_id: room_id
    },
    {
      connected() {
      },

      disconnected() {
        this.unsubscribe();
      },

      received(data) {
        if (data.type == 'dual') {
          this.dual(data);
        } else {
          console.log(data);
        }
      },

      dual(data) {
        if (data.status == 'request') {
          App.appView.invite_view.render(data.profile);
        } else if (data.status == 'approved') {
          this.data = data;
          App.appView.request_view.close();
          // NOTE: 시간차 문제 해결하기 위해 500 시간을 줌.
          setTimeout(this.startDualGame.bind(this), 500);
        } else if (data.status == "declined") {
          Helper.info({
            subject: "게임 거절",
            description:
              "상대방이 게임 요청을 거절하였습니다.",
          });
          App.appView.request_view.close();
        } else if (data.status == "canceled") {
          Helper.info({
            subject: "게임 취소",
            description:
              "상대방이 게임 요청을 취소하였습니다.",
          });
          App.appView.invite_view.close();
        }
      },

      dualRequest(user_id) {
        this.perform("dual_request", {id: user_id});
      },

      dualRequestDecline(user_id) {
        this.perform("dual_declined", {id: user_id});
      },

      dualRequestCancel(user_id) {
        this.perform("dual_cancel", {id: user_id});
      },

      startDualGame: function () {
        App.router.navigate(`#/matches?match-type=dual&match-id=${this.data.match_id}`)
      },
  });
}
