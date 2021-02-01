export let DirectChatView = Backbone.View.extend({
  template: _.template($("#direct-chat-view-template").html()),
  className: "ui text container",

  initialize: function () {
    // this.render();
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());
    $("#footer").append(this.$el);
  },
});
