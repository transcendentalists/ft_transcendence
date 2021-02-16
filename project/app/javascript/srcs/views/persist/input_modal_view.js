export let InputModalView = Backbone.View.extend({
  template: _.template($("#input-modal-view-template").html()),
  el: "#input-modal-view",

  initialize: function () {
    this.data = null;
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
    if (input == "") return App.router.navigate("#/errors/106");
    if (this.data.hasOwnProperty("success_callback"))
      this.data.success_callback(input);
    this.close();
  },
});
