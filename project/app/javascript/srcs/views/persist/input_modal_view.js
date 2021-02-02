export let InputModalView = Backbone.View.extend({
  template: _.template($("#input-modal-view-template").html()),
  el: "#input-modal-view",

  initialize: function () {
    this.dat = null;
  },

  events: {
    "click .green.button": "send",
    "click .cancel.button": "close",
  },

  render: function (data) {
    this.dat = data;
    this.$el.empty();
    this.$el.html(this.template(data));
    $("#input-modal-view.tiny.modal").modal("show");
    return this;
  },

  close: function () {
    this.$el.empty();
    $("#input-modal-view.tiny.modal").modal("hide");
  },

  send: function () {
    window.a1 = this.dat;
    window.a2 = this.$("textarea").val();
    let inpu = this.$("textarea").val();
    if (this.dat.hasOwnProperty("success_callback"))
      this.dat.success_callback(inpu);
    this.close();
  },
});
