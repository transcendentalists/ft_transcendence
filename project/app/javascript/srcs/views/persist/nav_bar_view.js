export let NavBarView = Backbone.View.extend({
  el: "#nav-bar-view",

  initialize: function () {
    this.$el.hide();
    this.home_menu = null;
  },

  render: function () {
    this.home_menu = $("[data-nav-value=home]");
    this.home_menu.addClass("active");
    this.$el.show();
    return this;
  },

  changeActiveItem: function (menu) {
    this.removeClass();
    $(`[data-nav-value=${menu}]`).addClass("active");
  },

  removeClass: function () {
    $(".ui.top.fixed.menu a.active").removeClass("active");
  },

  close: function () {
    this.removeClass("active");
    this.$el.hide();
  },
});
