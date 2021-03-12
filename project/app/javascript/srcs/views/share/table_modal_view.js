export let TableModalView = Backbone.View.extend({
  template: _.template($("#table-modal-view-template").html()),
  el: "#table-modal-view",

  events: {
    "click .close.icon": "hide",
  },

  initialize: function () {
    $("#table-modal-view").modal("setting", {
      closable: false,
    });
  },

  render: function (data) {
    this.$el.html(this.template(data));
    $("#table-modal-view.tiny.modal").modal("show");
    return this;
  },

  hide: function () {
    this.$el.empty();
    $("#table-modal-view.tiny.modal").modal("hide");
  },

  close: function () {
    this.hide();
  },
});
