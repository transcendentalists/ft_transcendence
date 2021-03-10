export let InfoModalView = Backbone.View.extend({
  template: _.template($("#info-modal-view-template").html()),
  el: "#info-modal-view",

  initialize: function () {
    this.modal_view = null;
  },

  render: function (data) {
    this.$el.html(this.template(data));
    this.modal_view = $("#info-modal-view.tiny.modal");
    this.modal_view.modal("show");
    return this;
  },

  close: function () {
    this.$el.empty();
    this.modal_view.modal("hide");
  },
});
