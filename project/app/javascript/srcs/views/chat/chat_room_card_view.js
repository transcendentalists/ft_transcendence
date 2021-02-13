export let ChatRoomCardView = Backbone.View.extend({
  template: _.template($("#chat-room-card-view-template").html()),
  className: "flex-container column-direction justify-content center-aligned",

  render: function () {
    this.$el.html(this.template());
    return this;
  },

  close: function () {
    this.remove();
  },
});
