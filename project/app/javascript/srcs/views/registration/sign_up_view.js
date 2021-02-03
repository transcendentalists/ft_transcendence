export let SignUpView = Backbone.View.extend({
  // template: _.template($("#sign-up-view-template").html()),

  render: function () {
    return this;
  },

  close: function () {
    this.remove();
  },
});
