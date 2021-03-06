import consumer from "channels/consumer";
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
        App.restart();
      },

      received(data) {
        switch (data.type) {
          case "dual":
            this.dual(data);
            break;
          case "service_ban":
            this.serviceBanned();
            break;
          case "same_browser_connection":
            this.browserAlert();
          default:
            console.log(data);
        }
      },

      /*
       ** Dual
       */

      dual(data) {
        let statuses = ["declined", "working", "canceled"];
        let descriptions = {
          declined: "상대방이 게임 요청을 거절하였습니다.",
          working: "상대방이 게임 진행이 불가능한 상태입니다.",
        };
        if (data.status == "request") {
          if (App.current_user.isWorking()) {
            this.dualRequestAlreadyExist(data.profile.id);
          } else App.app_view.invite_view.render(data);
        } else if (data.status == "approved") {
          App.app_view.request_view.close();
          this.dualGameStart(data);
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

      dualMatchHasCreated(challenger_id, match_id) {
        this.perform("dual_match_has_created", {
          challenger_id: challenger_id,
          match_id: match_id,
        });
      },

      dualGameStart: function (data) {
        if (data.match_id == null) {
          Helper.info({
            subject: "게임 생성 실패",
            description: "잘못된 정보를 입력하셨습니다.",
          });
          return;
        }

        App.router.navigate(
          `#/matches?match_type=dual&match_id=${data.match_id}`
        );
      },

      dualCloseInviteOrRequestView: function () {
        App.current_user.is_challenger
          ? App.app_view.request_view.close()
          : App.app_view.invite_view.close();
      },

      serviceBanned: function () {
        Helper.info({
          subject: "접속 제한",
          description: "정책 상의 이유로 서비스 이용이 제한되었습니다.",
        });
        setTimeout(App.restart.bind(App), 2000);
      },

      browserAlert: function () {
        Helper.info({
          subject: "중복 접속",
          description: "같은 브라우저에서 트렌센던스 접속이 감지되었습니다.",
        });
        setTimeout(App.restart.bind(App), 2000);
      },
    }
  );
}
