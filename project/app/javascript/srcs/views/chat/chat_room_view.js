import { Helper } from "../../helper";
import { App } from "../../internal";

export let ChatRoomView = Backbone.View.extend({
  id: "chat-room-view",
  template: _.template($("#chat-room-view-template").html()),
  entering_template: _.template($("#entering-chat-room-view-template").html()),
  className: "flex-container column-direction",

  initialize: function (room_id) {
    this.room_id = room_id;
    this.chat_message_list_view = null; // chat_message_collection
    this.chat_appearance_view = null; // chat_members
    this.chat_menu_view = null;
    this.current_member_menu_view = null;

    this.chat_message_collection = null;
    this.chat_members = null;
  },

  enterToChatRoom: function (data) {
    this.$el.html(this.template());
    this.chat_members = data.chat_room_members;

    // Helper.fetch({
    //   success_callback:
    // })

    console.log("success to enter to chat_room");
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
    console.log("🚀 ~ file: chat_room_view.js ~ line 31 ~ data", data);
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
        break;
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
    this.remove();
  },
});
