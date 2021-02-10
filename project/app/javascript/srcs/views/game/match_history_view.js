import { App } from "srcs/internal";

export let MatchHistoryView = Backbone.View.extend({
  // className: "ui text container",
  className: "match-history-view flex-container center-aligned",
  template: _.template($("#match-history-view-template").html()),

  initialize: function () {},

  render: function (data) {
    this.$el.html(this.template(data));
    return this;
  },

  close: function () {
    this.remove();
  },
});
