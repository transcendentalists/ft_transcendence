import { App } from "srcs/internal";

export let ChatIndexView = Backbone.View.extend({
  template: _.template($("#chat-index-view-template").html()),
  id: "chat-index-view",
  className: "flex-container column-direction center-aligned top-margin",

  initialize: function () {
    this.$el.html(this.template());
    this.my_chat_room_list_view = new App.View.ChatRoomCardListView();
    this.my_chat_room_list_view.setElement(this.$("#my-chat-room-list-view"));

    this.public_chat_room_list_view = new App.View.ChatRoomCardListView();
    this.public_chat_room_list_view.setElement(
      this.$("#public-chat-room-list-view")
    );
  },

  render: function () {
    this.my_chat_room_list_view.render();
    this.public_chat_room_list_view.render();
    return this;
  },

  close: function () {
    this.my_chat_room_list_view.close();
    this.group_chat_room_list_view.close();
    this.$el.empty();
    this.remove();
  },
});
