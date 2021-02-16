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

      /*
       ** Dual
       */

      dual(data) {
        let statuses = ["declined", "exist", "canceled"];
        let descriptions = {
          declined: "상대방이 게임 요청을 거절하였습니다.",
          exist: "상대방이 게임 진행이 불가능한 상태입니다.",
        };
        if (data.status == "request") {
          if (App.current_user.isWorking()) {
            this.dualRequestAlreadyExist(data.profile.id);
          } else App.appView.invite_view.render(data);
        } else if (data.status == "approved") {
          this.data = data;
          App.appView.request_view.close();
          // NOTE: 시간차 문제 해결하기 위해 500 시간을 줌.
          // score card 가 띄어졌는지 확인한다.
          setTimeout(this.dualGameStart.bind(this), 500);
        } else if (statuses.includes(data.status)) {
          if (data.status != "canceled") {
            Helper.info({
              subject: "게임 취소",
              description: descriptions[data.status],
            });
          }
          this.dualCloseInviteOrRequestView();
        }
      },

      dualRequest(enemy_id, rule_id, rule_name, target_score) {
        this.perform("dual_request", {
          id: enemy_id,
          rule_id: rule_id,
          rule_name: rule_name,
          target_score: target_score,
        });
      },

      dualRequestDecline(challenger_id) {
        this.perform("dual_declined", { id: challenger_id });
      },

      dualRequestCancel(enemy_id) {
        this.perform("dual_cancel", { id: enemy_id });
      },

      dualRequestAlreadyExist(challenger_id) {
        this.perform("dual_request_already_exist", { id: challenger_id });
      },

      dualGameStart: function () {
        if (this.data.match_id == null) {
          Helper.info({
            subject: "게임 생성 실패",
            description: "잘못된 정보를 입력하셨습니다.",
          });
          return;
        }

        App.router.navigate(
          `#/matches?match_type=dual&match_id=${this.data.match_id}`
        );
      },

      dualCloseInviteOrRequestView: function () {
        App.appView.request_view.enemy
          ? App.appView.request_view.close()
          : App.appView.invite_view.close();
      },
    }
  );
}
