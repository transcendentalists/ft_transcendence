import { App } from "srcs/helper";

export let ChatRoomCardView = Backbone.View.extend({
  template: _.template($("#chat-room-card-view-template").html()),
  className: "room-card flex-container column-direction justify-content",

  events: {
    "click .join.button": "join",
  },

  initialize: function () {
    this.room_id = null;
  },

  join: function (event) {
    this.room_id = event.target.getAttribute("data-room-id");
    App.router.navigate(`#/chatrooms/${this.room_id}`);
  },

  render: function (room) {
    this.$el.html(this.template(room));
    return this;
  },

  close: function () {
    this.room_id = null;
    this.remove();
  },
});
