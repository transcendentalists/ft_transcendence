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

  dualRequestTo: function (model) {
    if (this.isDualRequestPossible(model)) {
      App.appView.rule_modal_view.render(model);
    }
  },

  isDualRequestPossible: function (model) {
    if (this.get("status") == "playing") {
      Helper.info({
        subject: "대전 신청 불가능",
        description: "게임 중에는 대전 신청이 불가능합니다.",
      });
      return false;
    } else if (model.get("status") != "online") {
      Helper.info({
        subject: "대전 신청 불가능",
        description:
          model.get("name") + "님은 현재 " + model.get("status") + " 중입니다.",
      });
      return false;
    } else if (this.checkDualRequestOrInviteViewExist()) {
      Helper.info({
        subject: "대전 신청 불가능",
        description: "다른 유저와 대전 신청 중에는 대전 신청이 불가능합니다.",
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
          description: "상대방이 로그아웃 했습니다..",
        });
      }
    }
  },
});
