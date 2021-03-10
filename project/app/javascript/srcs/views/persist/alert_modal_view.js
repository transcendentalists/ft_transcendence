export let AlertModalView = Backbone.View.extend({
  template: _.template($("#alert-modal-view-template").html()),
  el: "#alert-modal-view",

  initialize: function () {
    this.data = null;
  },

  events: {
    "click .positive.button": "approve",
    "click .negative.button": "close",
  },

  render: function (data) {
    this.data = data;
    this.$el.empty();
    this.$el.html(this.template(data));
    $("#alert-modal-view.tiny.modal").modal("show");
    return this;
  },

  close: function () {
    this.$el.empty();
    $("#alert-modal-view.tiny.modal").modal("hide");
  },

  approve: function () {
    if (this.data.success_callback) data.success_callback();
    this.close();
  },
});
