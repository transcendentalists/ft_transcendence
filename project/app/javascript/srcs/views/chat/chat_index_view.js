import { App, Helper } from "srcs/internal";

export let ChatIndexView = Backbone.View.extend({
  template: _.template($("#chat-index-view-template").html()),
  id: "chat-index-view",
  className: "flex-container column-direction center-aligned top-margin",
  events: {
    "click .create.button": "createChatRoom",
    "click .search.label": "search",
  },

  initialize: function () {
    this.$el.html(this.template());
  },

  createChatRoom: function () {
    App.router.navigate("#/chatrooms/new");
  },

  search: function () {
    const input = $(".labeled.input input").val();
    if (input == "") return;
    const chat_room_search_url = `group_chat_rooms?channel_code=${input}`;
    Helper.fetch(chat_room_search_url, {
      success_callback: function (data) {
        App.router.navigate("#/chatrooms/" + data.group_chat_rooms.id);
      }.bind(this),
    });
  },

  renderMyChatRoomCallback: function (data) {
    if (!data["group_chat_rooms"]) return;
    this.my_chat_room_list_view = new App.View.ChatRoomCardListView();
    this.my_chat_room_list_view.setElement(this.$("#my-chat-room-list-view"));
    this.my_chat_room_list_view.render(data.group_chat_rooms);
  },

  renderPublicChatRoomCallback: function (data) {
    if (!data["group_chat_rooms"]) return;
    this.public_chat_room_list_view = new App.View.ChatRoomCardListView();
    this.public_chat_room_list_view.setElement(
      this.$("#public-chat-room-list-view")
    );
    this.public_chat_room_list_view.render(data.group_chat_rooms);
  },

  render: function () {
    const my_chat_room_url = "group_chat_rooms?for=my_group_chat_room_list";
    Helper.fetch(my_chat_room_url, {
      success_callback: this.renderMyChatRoomCallback.bind(this),
    });

    const public_chat_room_url = "group_chat_rooms?room_type=public";
    Helper.fetch(public_chat_room_url, {
      success_callback: this.renderPublicChatRoomCallback.bind(this),
    });

    return this;
  },

  close: function () {
    if (this.my_chat_room_list_view) this.my_chat_room_list_view.close();
    if (this.public_chat_room_list_view)
      this.public_chat_room_list_view.close();
    this.$el.empty();
    this.remove();
  },
});
