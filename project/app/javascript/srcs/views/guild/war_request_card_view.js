export let WarRequestCardView = Backbone.View.extend({
  template: _.template($("#war-request-card-view-template").html()),
  className:
    "ui segment profile-card war-request-card flex-container center-aligned",

  initialize: function () {},

  render: function (data) {
    console.log(data);
    this.$el.html(this.template(data));
    return this;
  },

  close: function () {
    this.$el.empty();
    this.remove();
  },
});
