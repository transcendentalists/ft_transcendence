import { App, Helper } from "srcs/internal";

export let ChatRoomView = Backbone.View.extend({
  id: "chat-room-view",
  template: _.template($("#chat-room-view-template").html()),
  className: "flex-container column-direction",
  events: {
    "click .submit.button": "send",
    "mouseenter #chat-room-right-area": "hideMemberMenu",
  },

  initialize: function (room_id) {
    Helper.authenticateREST(room_id);
    if (!Helper.isNumber(room_id)) return App.router.navigate("#/errors/404");
    this.room_id = room_id;
    this.chat_message_list_view = null;
    this.chat_room_member_list_view = null;
    this.chat_room_menu_view = null;
    this.chat_messages = null;
    this.chat_room_members = null;
    this.current_user_membership = null;
    this.channel = null;
  },

  render: function () {
    this.tryEnteringChatRoom();
    return this;
  },

  tryEnteringChatRoom: function (password = null) {
    let headers = {};
    if (password !== null) headers.Authorization = password;

    Helper.fetch(`group_chat_rooms/${this.room_id}`, {
      headers: headers,
      success_callback: this.enterChatRoom.bind(this),
      fail_callback: this.enterFailCallback.bind(this),
    });
  },

  enterChatRoom: function (data) {
    this.$el.html(this.template());

    this.readyToRenderChatRoom(data);

    this.chat_room_member_list_view.render();
    this.chat_room_menu_view.render();
    this.fetchAndRenderChatMessages();

    this.connectChannelAndListenEvent();
  },

  readyToRenderChatRoom: function (data) {
    this.chat_room_members = new App.Collection.GroupChatMembers(
      data.chat_room_members,
      { room_id: this.room_id }
    );

    this.current_user_membership = this.chat_room_members.get(
      App.current_user.id
    );

    this.chat_room_member_list_view = new App.View.ChatRoomMemberListView({
      parent: this,
    });

    this.chat_room_menu_view = new App.View.ChatRoomMenuView({
      parent: this,
      room: data.group_chat_room,
    });
    this.chat_room_menu_view.setElement(this.$("#chat-room-menu-view"));
  },

  fetchAndRenderChatMessages: function () {
    this.chat_messages = new App.Collection.GroupChatMessages(this.room_id);
    this.chat_message_list_view = new App.View.GroupChatMessageListView({
      parent: this,
    });
    this.chat_messages.fetch({
      reset: true,
    });
  },

  connectChannelAndListenEvent: function () {
    this.channel = App.Channel.ConnectGroupChatChannel(
      this.chat_messages,
      this.room_id,
      this.chat_room_members
    );

    this.listenTo(
      this.chat_room_members,
      "change:position",
      this.letOutIfKicked
    );
  },

  /**
   ** 401: 패스워드 필요
   ** 403: 서버사이드 패스워드 유효성 검사 실패, 챗룸 인원 초과, 챗룸 입장 금지
   ** 404: 챗룸 탐색 실패
   */
  enterFailCallback: function (data) {
    if (data.error == undefined || data.error.code == undefined)
      return App.router.navigate("#/errors/500");

    const code = data.error.code;
    const type = data.error.type;
    const msg = data.error.msg;
    switch (code) {
      case 401:
        this.showPasswordInputModal();
        break;
      case 403:
      case 404:
        return App.router.navigate(`#/errors/${code}/${type}/${msg}`);
      default:
        return App.router.navigate("#/errors/500");
    }
  },

  showPasswordInputModal: function () {
    Helper.input({
      subject: "입장 검사",
      description: "룸 입장을 위해 비밀번호를 입력해주세요.",
      success_callback: function (password) {
        this.tryEnteringChatRoom(password);
      }.bind(this),
      cancel_callback: function () {
        App.router.navigate("#/chatrooms");
      },
    });
  },

  send: function () {
    let msg = this.$el.find(".reply-field").val();
    if (msg == "") return;
    if (this.channel == null) return;
    this.$el.find(".reply-field").val("");
    this.channel.speak({
      image_url: App.current_user.get("image_url"),
      name: App.current_user.get("name"),
      message: msg,
      type: "msg",
      user_id: App.current_user.id,
    });
  },

  hideMemberMenu: function (event) {
    if (this.chat_room_member_list_view)
      this.chat_room_member_list_view.hideMemberMenu(event);
  },

  letOutIfKicked: function (chat_room_member) {
    if (chat_room_member.get("position") !== "ghost") return;

    if (App.current_user.equalTo(chat_room_member)) {
      App.router.navigate("#/chatrooms");
      Helper.info({
        subject: "강제 퇴장",
        description: "챗룸에서 강제 퇴장되었습니다.",
      });
    }
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
