export let MainView = Backbone.View.extend({
  el: "#temp-view",

  initialize: function () {
    console.log("MainView");
    this.current_view = null;
  },

  render: function (main_view) {
    if (this.current_view) this.current_view.close();
    this.current_view = main_view;
    this.$el.empty();
    this.$el.append(this.current_view.render().$el);
  },
});
