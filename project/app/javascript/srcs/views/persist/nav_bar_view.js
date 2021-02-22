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
    $("[data-nav-value=home]").addClass("active");
    this.$el.show();
    return this;
  },

  close: function () {
    $(".ui.top.fixed.menu a.active").removeClass("active");
    this.$el.hide();
  },
});
