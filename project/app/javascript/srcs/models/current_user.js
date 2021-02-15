import { App, Helper } from "srcs/internal";

export let CurrentUser = Backbone.Model.extend({
  urlRoot: "/api/users/",

  initialize: function () {
    this.is_admin = false;
    this.sign_in = false;
  },

  logout: function () {
    this.is_admin = false;
    this.sign_in = false;
  },

  parse: function (response) {
    return response.user;
  },

  login: function () {
    this.sign_in = true;
    this.fetch({
      data: { for: "profile" },
    });
  },

  update_status: function (status) {
    this.set("status", status)
  },

  dualRequestTo: function (enemy) {
    if (this.isDualRequestPossibleTo(enemy)) {
      App.appView.rule_modal_view.render(enemy);
    }
  },

  isDualRequestPossibleTo: function (enemy) {
    let description = null;
    if (this.get("status") == "playing") {
      description = "게임 중에는 대전 신청이 불가능합니다.";
    } else if (enemy.get("status") != "online") {
      description =
        enemy.get("status") == "offline"
          ? enemy.get("name") + "님은 현재 로그아웃 상태입니다."
          : enemy.get("name") + "님은 현재 게임중입니다.";
    } else if (this.checkDualRequestOrInviteViewExist()) {
      description = "다른 유저와 대전 신청 중에는 대전 신청이 불가능합니다.";
    }
    if (description != null) {
      Helper.info({
        subject: "대전 신청 불가능",
        description: description,
      });
      return false;
    }
    return true;
  },

  checkDualRequestOrInviteViewExist: function () {
    return (
      $("#invite-view").is(":visible") || $("#request-view").is(":visible")
    );
  },

  checkDualRequestOrInviteAndRemove: function (user) {
    if (user.status == "offline" && this.checkDualRequestOrInviteViewExist()) {
      let id = $("#invite-view").is(":visible")
        ? App.appView.invite_view.challenger.profile.id
        : App.appView.request_view.enemy.id;
      if (user.id == id) {
        $("#invite-view").is(":visible")
          ? App.appView.invite_view.close()
          : App.appView.request_view.close();
        Helper.info({
          subject: "게임 취소",
          description: "상대방이 로그아웃했습니다.",
        });
      }
    }
  },
});
