import { Helper } from "srcs/internal";

export let WarRuleView = Backbone.View.extend({
  template: _.template($("#war-rule-view-template").html()),

  render: function (war_rule) {
    war_rule = war_rule;
    war_rule.rule.name = Helper.translateRule(war_rule.rule.name);
    this.$el.html(this.template(war_rule));
    return this;
  },

  close: function () {
    this.remove();
  },
});
