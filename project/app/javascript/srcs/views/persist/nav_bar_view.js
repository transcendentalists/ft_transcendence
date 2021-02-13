export let NavBarView = Backbone.View.extend({
  el: "#nav-bar-view",
  events: {
    "click .ui.top.fixed.menu a": "changeActiveItem",
  },

  changeActiveItem: function (e) {
    $(".ui.top.fixed.menu a.active").removeClass("active");
    e.target.classList.add("active");
  },

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
