import { App } from "srcs/internal";

export let InputModalView = Backbone.View.extend({
  template: _.template($("#input-modal-view-template").html()),
  el: "#input-modal-view",

  initialize: function () {
    this.data = null;
    $("#input-modal-view.tiny.modal").modal("setting", {
      closable: false,
    });
  },

  events: {
    "click .green.button": "send",
    "click .cancel.button": "cancel",
  },

  render: function (data) {
    this.data = data;
    this.$el.empty();
    this.$el.html(this.template(data));
    $("#input-modal-view.tiny.modal").modal("show");
    return this;
  },

  cancel: function () {
    if (this.data.cancel_callback != undefined) this.data.cancel_callback();
    this.close();
  },

  close: function () {
    this.$el.empty();
    $("#input-modal-view.tiny.modal").modal("hide");
  },

  send: function () {
    let input = this.$("input").val();
    this.$("input").val("");
    if (this.data.hasOwnProperty("success_callback"))
      this.data.success_callback(input);
    this.close();
  },
});
