export let InviteView = Backbone.View.extend({
  template: _.template($("#invite-view-ver-a-template").html()),

  initialize: function () {
    // this.render();
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());
    $("#footer").append(this.$el);
  },

  close: function () {
    this.$el.empty();
  },
});
