import { App, Helper } from "srcs/internal";

export let CurrentUser = Backbone.Model.extend({
  urlRoot: "/api/users/",

  initialize: function () {
    this.is_admin = false;
    this.sign_in = false;
    this.working = false;
    this.is_challenger = false;
  },

  logout: function () {
    this.is_admin = false;
    this.sign_in = false;
    this.working = false;
    this.is_challenger = false;
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
    this.set("status", status);
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
    } else if (this.isWorking()) {
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

  isWorking: function () {
    return this.working;
  },
});
