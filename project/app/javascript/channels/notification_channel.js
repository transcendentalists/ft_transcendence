import consumer from "./consumer";
import { App, Helper } from "srcs/internal";

export function ConnectNotificationChannel(room_id) {
  return consumer.subscriptions.create(
    {
      channel: "NotificationChannel",
      room_id: room_id,
    },
    {
      connected() {},

      disconnected() {
        this.unsubscribe();
      },

      received(data) {
        if (data.type == "dual") {
          this.dual(data);
        } else {
          console.log(data);
        }
      },

      dual(data) {
        if (data.status == "request") {
          if (this.checkViewVisible(data)) return;
          App.appView.invite_view.render(data);
        } else if (data.status == "approved") {
          this.data = data;
          App.appView.request_view.close();
          // NOTE: 시간차 문제 해결하기 위해 500 시간을 줌.
          setTimeout(this.startDualGame.bind(this), 500);
        } else if (data.status == "declined") {
          Helper.info({
            subject: "게임 거절",
            description: "상대방이 게임 요청을 거절하였습니다.",
          });
          App.appView.request_view.close();
        } else if (data.status == "canceled") {
          Helper.info({
            subject: "게임 취소",
            description: "상대방이 게임 요청을 취소하였습니다.",
          });
          App.appView.invite_view.close();
        } else if (data.status == "exist") {
          Helper.info({
            subject: "게임 신청 불가능",
            description: "상대방은 다른 유저의 대전 신청을 받고 있습니다.",
          });
          App.appView.request_view.close();
        }
      },

      dualRequest(user_id, rule_id, target_score) {
        this.perform("dual_request", {
          id: user_id,
          rule_id: rule_id,
          target_score: target_score,
        });
      },

      dualRequestDecline(user_id) {
        this.perform("dual_declined", { id: user_id });
      },

      dualRequestCancel(user_id) {
        this.perform("dual_cancel", { id: user_id });
      },

      dualRequestExist(user_id) {
        this.perform("dual_request_exist", { id: user_id });
      },

      checkViewVisible: function (data) {
        if (App.current_user.checkDualRequestOrInviteViewExist()) {
          this.dualRequestExist(data.profile.id);
          return true;
        }
        return false;
      },

      startDualGame: function () {
        App.router.navigate(
          `#/matches?match-type=dual&match-id=${this.data.match_id}`,
        );
      },
    },
  );
}
