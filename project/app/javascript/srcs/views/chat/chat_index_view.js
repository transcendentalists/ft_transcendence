import { App } from "srcs/internal";

export let ChatIndexView = Backbone.View.extend({
  template: _.template($("#chat-index-view-template").html()),
  id: "chat-index-view",
  className: "flex-container column-direction center-aligned top-margin",

  initialize: function () {
    this.my_chat_room_list_view = new App.View.ChatRoomCardListView(
      "#my-chat-room-list-view"
    );
    this.group_chat_room_list_view = new App.View.ChatRoomCardListView({
      el: "#group-chat-room-list-view",
    });
  },

  render: function () {
    this.$el.html(this.template());
    this.my_chat_room_list_view.render();
    this.group_chat_room_list_view.render();
    return this;
  },

  close: function () {
    this.my_chat_room_list_view.close();
    this.group_chat_room_list_view.close();
    this.remove();
  },
});
