import { App, Helper } from "srcs/internal";

export let RuleModalView = Backbone.View.extend({
  template: _.template($("#rule-modal-view-template").html()),
  el: "#rule-modal-view",

  initialize: function () {
    this.model = null;
  },

  events: {
    "click .green.button": "submit",
    "click .cancel.button": "close",
  },

  render: function (model) {
    this.model = model;
    this.$el.empty();
    this.$el.html(this.template());
    $("#rule-modal-view.tiny.modal").modal("show");
    return this;
  },

  close: function () {
    this.$el.empty();
    this.model = null;
    $("#rule-modal-view.tiny.modal").modal("hide");
  },

  isEnemyOnline: function () {
    let user_unit_view = $(
      `#appearance-view:contains("${this.model.get("name")}")`,
    );
    if (!user_unit_view.length) return false;
    let user_unit_views = $("#appearance-view")
      .find("[data-status=online]")
      .parent();
    for (let user_unit_view of user_unit_views) {
      if (user_unit_view.textContent.trim() == this.model.get("name")) {
        return true;
      }
    }
    return false;
  },

  submit: function () {
    let description = null;
    if (this.isEnemyOnline() == false) {
      description = "상대방이 로그아웃 했습니다.";
    } else if (App.current_user.checkDualRequestOrInviteViewExist()) {
      description = "다른 유저와 대전 신청 중에는 대전 신청이 불가능합니다.";
    }
    if (description != null) {
      Helper.info({
        subject: "게임 신청 불가능",
        description: description,
      });
      return;
    }
    let rule_id = $("select[name=rules]").val();
    let rule_name = $("select[name=rules] option:checked").text();
    let target_score = this.$el.find('[name="score"]:checked').val();
    App.notification_channel.dualRequest(
      this.model.id,
      rule_id,
      rule_name,
      target_score,
    );
    App.appView.request_view.render(this.model.attributes);
    this.close();
  },
});
