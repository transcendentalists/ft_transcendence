import { Helper } from "../../helper";
import { App } from "../../internal";

export let ChatRoomView = Backbone.View.extend({
  id: "chat-room-view",
  template: _.template($("#chat-room-view-template").html()),
  entering_template: _.template($("#entering-chat-room-view-template").html()),
  className: "flex-container column-direction",
  events: {
    "click .submit.button": "send",
  },

  initialize: function (room_id) {
    this.room_id = room_id;
    this.chat_message_list_view = null; // chat_message_collection
    this.chat_room_member_list_view = null; // chat_members
    this.current_member_menu_view = null;
    this.chat_room_menu_view = null;

    this.chat_messages = null;
    this.chat_room_members = null;
    this.channel = null;
  },

  send: function () {
    let msg = this.$el.find($(".reply-field")).val();
    if (msg == "") return;
    if (this.channel == null) return;
    $(".reply-field").val("");
    this.channel.speak({
      image_url: App.current_user.get("image_url"),
      name: App.current_user.get("name"),
      created_at: new Date(),
      message: msg,
      user_id: App.current_user.get("id"),
    });
  },

  renderChatMessages: function () {
    this.chat_messages = new App.Collection.GroupChatMessages(this.room_id);
    this.chat_message_list_view = new App.View.GroupChatMessageListView({
      parent: this,
    });
    this.chat_messages.fetch({ reset: true });
  },

  enterToChatRoom: function (data) {
    this.$el.html(this.template());
    this.chat_room_members = new App.Collection.Users(data.chat_room_members);
    this.chat_room_member_list_view = new App.View.ChatRoomMemberListView({
      parent: this,
    });
    this.chat_room_member_list_view.render();

    this.chat_room_menu_view = new App.View.ChatRoomMenuView({
      parent: this,
    });
    this.chat_room_menu_view.setElement(this.$("#chat-room-menu-view"));
    this.chat_room_menu_view.render();

    this.renderChatMessages();
    this.channel = App.Channel.ConnectGroupChatChannel(
      this.chat_messages,
      this.room_id
    );
  },

  showPasswordInputModal: function () {
    Helper.input({
      subject: "입장 검사",
      description: "룸 입장을 위해 비밀번호를 입력해주세요.",
      success_callback: function (password) {
        this.tryToEnterToChatRoom(password);
      }.bind(this),
      cancel_callback: function () {
        App.router.navigate("#/chatrooms");
      },
    });
  },

  /**
   ** 401: 패스워드 필요
   ** 403: 서버사이드 패스워드 유효성 검사 실패
   ** 404: 챗룸 탐색 실패
   */
  enterFailCallback: function (data) {
    if (data.error == undefined || data.error.code == undefined)
      return App.router.navigate("#/errors/500");

    const code = data.error.code;
    switch (code) {
      case "401":
        this.showPasswordInputModal();
        break;
      case "403":
      case "404":
        return App.router.navigate("#/errors/" + code);
      default:
        return App.router.navigate("#/errors/500");
    }
  },

  tryToEnterToChatRoom: function (password = null) {
    let headers = Helper.current_user_header();
    if (password !== null) headers.Authorization = password;

    Helper.fetch(`group_chat_rooms/${this.room_id}`, {
      headers: headers,
      success_callback: this.enterToChatRoom.bind(this),
      fail_callback: this.enterFailCallback.bind(this),
    });
  },

  render: function () {
    this.$el.html(this.entering_template());
    this.tryToEnterToChatRoom();
    return this;
  },

  close: function () {
    if (this.chat_message_list_view) this.chat_message_list_view.close();
    if (this.chat_room_member_list_view)
      this.chat_room_member_list_view.close();
    if (this.chat_room_menu_view) this.chat_room_menu_view.close();

    this.chat_messages = null;
    this.chat_room_members = null;
    if (this.channel) this.channel.unsubscribe();

    this.remove();
  },
});
