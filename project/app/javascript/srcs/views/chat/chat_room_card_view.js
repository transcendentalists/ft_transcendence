export let ChatRoomCardView = Backbone.View.extend({
  template: _.template($("#chat-room-card-view-template").html()),
  className: "room-card flex-container column-direction justify-content",

  render: function () {
    this.$el.html(this.template());
    return this;
  },

  close: function () {
    this.remove();
  },
});
