export let InfoModalView = Backbone.View.extend({
  template: _.template($("#info-modal-view-template").html()),
  el: "#info-modal-view",

  render: function (data) {
    this.$el.html(this.template(data));
    $("#info-modal-view.tiny.modal").modal("show");
    return this;
  },

  close: function () {
    this.$el.empty();
    $("#info-modal-view.tiny.modal").modal("hide");
  },
});
