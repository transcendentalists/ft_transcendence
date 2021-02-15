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

  submit: function () {
    let rule_id = $("select[name=rules]").val();
    let rule_name = $("select[name=rules] option:checked").text();
    let target_score = this.$el.find('[name="score"]:checked').val();
    if (App.current_user.checkDualRequestOrInviteViewExist()) {
      Helper.info({
        subject: "게임 신청 불가능",
        description: "다른 유저와 대전 신청 중에는 대전 신청이 불가능합니다.",
      });
      this.close();
      return;
    }
    App.notification_channel.dualRequest(this.model.id, rule_id, rule_name, target_score);
    App.appView.request_view.render(this.model.attributes);
    this.close();
  },
});
