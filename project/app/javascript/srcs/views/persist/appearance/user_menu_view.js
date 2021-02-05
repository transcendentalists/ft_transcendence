export let UserMenuView = Backbone.View.extend({
  template: _.template($("#user-menu-view-template").html()),

  events: {
    mouseleave: "close",
    // mousedown: "close",
    // blur: "close",
  },

  render: function (position) {
    this.$el.html(this.template(this.model));
    this.$el.css("position", "absolute");
    this.$el.css("top", position.top);
    this.$el.css("left", position.left - 127);
    this.$el.css("z-index", 103);
    return this;
  },

  clear: function () {
    this.template;
  },

  close: function () {
    this.$el.remove();
  },
});
