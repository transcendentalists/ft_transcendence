export let NavBarView = Backbone.View.extend({
  el: "#nav-bar-view",
  initialize: function () {
    this.$el.hide();
  },

  render: function () {
    this.$el.show();
    return this;
  },

  close: function () {
    this.$el.hide();
  },
});
