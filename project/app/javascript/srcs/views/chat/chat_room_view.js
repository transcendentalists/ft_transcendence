export let ChatRoomView = Backbone.View.extend({
  id: "chat-room-view",
  template: _.template($("#chat-room-view-template").html()),
  className: "flex-container column-direction",

  initialize: function () {},

  render: function () {
    this.$el.html(this.template());
    return this;
  },

  close: function () {
    this.remove();
  },
});
