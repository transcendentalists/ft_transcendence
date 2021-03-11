export let AlertModalView = Backbone.View.extend({
  template: _.template($("#alert-modal-view-template").html()),
  el: "#alert-modal-view",

  events: {
    "click .positive.button": "approve",
    "click .negative.button": "close",
  },

  initialize: function () {
    this.data = null;
    this.modal_view = null;
  },

  render: function (data) {
    this.data = data;
    this.$el.empty();
    this.$el.html(this.template(data));
    this.modal_view = "#alert-modal-view.tiny.modal";
    $(this.modal_view).modal("show");
    return this;
  },

  close: function () {
    this.$el.empty();
    $(this.modal_view).modal("hide");
  },

  approve: function () {
    if (this.data.success_callback) data.success_callback();
    this.close();
  },
});
