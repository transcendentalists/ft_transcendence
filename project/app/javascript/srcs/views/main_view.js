export let MainView = Backbone.View.extend({
  el: "#main-view-container",

  initialize: function () {
    this.current_view = null;
  },

  render: function (main_view_prototype, param) {
    if (this.current_view) this.current_view.close();
    this.current_view = new main_view_prototype(param);
    this.$el.empty();
    this.$el.append(this.current_view.render().$el);
  },

  close: function () {
    this.current_view.close();
  },
});
