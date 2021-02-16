import { App, Helper, DualHelper } from "srcs/internal";

export let RuleModalView = Backbone.View.extend({
  template: _.template($("#rule-modal-view-template").html()),
  el: "#rule-modal-view",

  initialize: function () {
    this.enemy = null;
  },

  events: {
    "click .green.button": "submit",
    "click .cancel.button": "close",
  },

  render: function (enemy) {
    if (DualHelper.addLitsenToUserModel(this, enemy.id)) {
      this.enemy = enemy;
      App.current_user.working = true;
      this.$el.html(this.template());
      $("#rule-modal-view.tiny.modal").modal("show");
      return this;
    }
  },

  clear: function () {
    this.stopListening();
    this.$el.empty();
    this.enemy = null;
    $("#rule-modal-view.tiny.modal").modal("hide");
  },

  close: function () {
    this.clear();
    App.current_user.working = false;
  },

  submit: function () {
    let rule_id = $("select[name=rules]").val();
    let rule_name = $("select[name=rules] option:checked").text();
    let target_score = this.$el.find('[name="score"]:checked').val();

    App.notification_channel.dualRequest(
      this.enemy.id,
      rule_id,
      rule_name,
      target_score
    );
    App.appView.request_view.render(this.enemy.attributes);
    this.clear();
  },
});
