import { App, Helper } from "srcs/internal";

export let CurrentUser = Backbone.Model.extend({
  urlRoot: "/api/users/",

  initialize: function () {
    this.sign_in = false;
    this.two_factor_auth = false;
    this.working = false;
    this.is_challenger = false;
  },

  logout: function () {
    this.sign_in = false;
    this.two_factor_auth = false;
    this.working = false;
    this.is_challenger = false;
  },

  parse: function (response) {
    return response.user;
  },

  login: function (id) {
    this.sign_in = true;
    this.set("id", id);
    this.fetch({
      data: { for: "profile" },
      success: () => {
        App.app_view.render();
        App.router.navigate(`#/users/${this.id}`);
      },
    });
  },

  update_status: function (status) {
    this.set("status", status);
  },

  dualRequestTo: function (enemy) {
    if (this.isDualRequestPossibleTo(enemy)) {
      App.app_view.rule_modal_view.render(enemy);
    } else {
      this.alertDualImpossibleModal(enemy);
    }
  },

  isDualRequestPossibleTo: function (enemy) {
    return this.get("status") !== "playing" && enemy.get("status") === "online";
  },

  alertDualImpossibleModal: function (enemy) {
    const my_status = this.get("status");
    const enemy_status = enemy.get("status");
    const status_hash = { playing: "게임중인", offline: "오프라인" };
    let [name, status] = [this.get("name"), my_status];

    if (enemy_status !== "online")
      [name, status] = [enemy.get("name"), enemy_status];

    Helper.info({
      subject: "대전 신청 불가능",
      description: `${name}님은 현재 ${status_hash[status]} 상태입니다.`,
    });
  },

  isWorking: function () {
    return this.working;
  },
});
