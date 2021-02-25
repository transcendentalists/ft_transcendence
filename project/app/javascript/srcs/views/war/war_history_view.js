import { App, Helper } from "srcs/helper";

export let WarHistoryView = Backbone.View.extend({
  template: _.template($("#war-history-view-template").html()),
  className: "war-history-view flex-container center-aligned",

  initialize: function (guild_id) {
    this.guild_id = guild_id;
  },

  render: function (data) {
    this.$el.html(this.template(data));
    return this;
  },

  close: function () {
    this.remove();
  },
});