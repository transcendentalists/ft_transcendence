export let InputModalView = Backbone.View.extend({
  template: _.template($("#input-modal-view-template").html()),
  el: "#input-modal-view",

  initialize: function () {
    this.data = null;
  },

  events: {
    "click .green.button": "send",
    "click .cancel.button": "close",
  },

  render: function (data) {
    this.data = data;
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
    let input = this.$("textarea").val();
    if (this.data.hasOwnProperty("success_callback"))
      this.data.success_callback(input);
    this.close();
  },
});
