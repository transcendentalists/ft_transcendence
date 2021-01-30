export let SignInView = Backbone.View.extend({
  // template: _.template($("#sign-in-view-template").html()),

  render: function () {
    return this;
  },

  close: function () {
    this.remove();
  },
});
