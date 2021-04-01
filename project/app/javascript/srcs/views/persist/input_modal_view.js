export let InputModalView = Backbone.View.extend({
  template: _.template($("#input-modal-view-template").html()),
  el: "#input-modal-view",
  events: {
    "click .green.button": "send",
    "click .cancel.button": "cancel",
  },

  initialize: function () {
    this.data = null;
    this.modal_view = "#input-modal-view.tiny.modal";
    $(this.modal_view).modal("setting", {
      closable: false,
    });
    this.input = null;
  },

  render: function (data) {
    this.data = data;
    this.$el.empty();
    this.$el.html(this.template(data));
    $(this.modal_view).modal("show");
    this.input = this.$("input");
    return this;
  },

  cancel: function () {
    if (this.data.cancel_callback != undefined) this.data.cancel_callback();
    this.close();
  },

  send: function () {
    if (!this.input) return;
    let input = this.input.val();
    this.input.val("");
    if (this.data.success_callback) this.data.success_callback(input);
    this.close();
  },

  close: function () {
    this.$el.empty();
    $(this.modal_view).modal("hide");
  },
});
