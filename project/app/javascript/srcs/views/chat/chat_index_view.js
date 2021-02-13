import { App, Helper } from "srcs/internal";

export let ChatIndexView = Backbone.View.extend({
  template: _.template($("#chat-index-view-template").html()),
  id: "chat-index-view",
  className: "flex-container column-direction center-aligned top-margin",

  initialize: function () {
    this.$el.html(this.template());
  },

  renderMyChatRoomCallback: function (data) {
    console.log("🚀 ~ file: chat_index_view.js ~ line 13 ~ data", data);
    this.my_chat_room_list_view = new App.View.ChatRoomCardListView();
    this.my_chat_room_list_view.setElement(this.$("#my-chat-room-list-view"));
    this.my_chat_room_list_view.render(data.group_chat_rooms);
  },

  renderPublicChatRoomCallback: function (data) {
    console.log("🚀 ~ file: chat_index_view.js ~ line 20 ~ data", data);
    this.public_chat_room_list_view = new App.View.ChatRoomCardListView();
    this.public_chat_room_list_view.setElement(
      this.$("#public-chat-room-list-view")
    );
    this.public_chat_room_list_view.render(data.group_chat_rooms);
  },

  render: function () {
    const my_chat_room_url = `group_chat_rooms?for=my_group_chat_room_list&current_user_id=${App.current_user.id}`;
    Helper.fetch(my_chat_room_url, {
      success_callback: this.renderMyChatRoomCallback.bind(this),
    });

    const public_chat_room_url = `group_chat_rooms?room_type=public&current_user_id=${App.current_user.id}`;
    Helper.fetch(public_chat_room_url, {
      success_callback: this.renderPublicChatRoomCallback.bind(this),
    });

    return this;
  },

  close: function () {
    this.my_chat_room_list_view.close();
    this.group_chat_room_list_view.close();
    this.$el.empty();
    this.remove();
  },
});
