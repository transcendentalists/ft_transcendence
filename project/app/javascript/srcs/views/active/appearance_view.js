export let AppearenceView = Backbone.View.extend({
  el: "#appearance-view",
  template: _.template($("#appearance-view-template").html()),

  initialize: function () {
    // this.$el.hide();
    // this.render();
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());
  },
});
