export let WarRuleView = Backbone.View.extend({
  template: _.template($("#war-rule-view-template").html()),

  initialize: function () {},

  render: function (war_rule) {
    this.$el.html(this.template(war_rule));
    return this;
  },

  close: function () {
    this.remove();
  },
});
