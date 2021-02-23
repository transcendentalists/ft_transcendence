import { App, Helper } from "srcs/internal";

export let ChatRoomMenuView = Backbone.View.extend({
  template: _.template($("#chat-room-menu-view-template").html()),

  events: {
    "click [data-event-name=change-room-info]": "renderChangeRoomPasswordModal",
    "click [data-event-name=back-to-chat-room-list]": "backToChatRoomList",
    "click [data-event-name=leave-from-chat-room]": "leaveFromChatRoom",
  },

  initialize: function (options) {
    this.parent = options.parent;
    this.room = options.room;
    this.room_id = this.parent.room_id;
    this.chat_room_members = this.parent.chat_room_members;
    this.current_user_as_room_member = this.chat_room_members.get(
      App.current_user.id
    );

    this.listenTo(
      this.current_user_as_room_member,
      "change:position",
      this.showOrHideButtonsByPosition
    );
  },

  changePasswordRequest: function (password) {
    Helper.fetch(`group_chat_rooms/${this.room_id}`, {
      method: "PATCH",
      body: {
        group_chat_room: {
          password: password,
        },
      },
    });
  },

  renderChangeRoomPasswordModal: function () {
    Helper.input({
      subject: "새로운 비밀번호 입력",
      description: "비밀번호 미입력시 누구나 들어올 수 있습니다.",
      success_callback: function (password) {
        this.changePasswordRequest(password);
      }.bind(this),
    });
  },

  backToChatRoomList: function () {
    App.router.navigate("#/chatrooms");
  },

  leaveFromChatRoom: async function () {
    this.parent.channel.unsubscribe();
    await this.chat_room_members.letOutOfChatRoom(
      this.current_user_as_room_member
    );
    App.router.navigate("#/chatrooms");
  },

  showAuthorizedButtonsToOwner: function () {
    this.$el.find(".owner-auth").show();
  },

  hideAuthorizedButtonsToOwner: function () {
    this.$el.find(".owner-auth").hide();
  },

  showOrHideButtonsByPosition: function () {
    if (this.current_user_as_room_member.get("position") == "owner") {
      this.showAuthorizedButtonsToOwner();
    } else {
      this.hideAuthorizedButtonsToOwner();
    }
  },

  render: function () {
    this.$el.html(this.template(this.room));
    this.showOrHideButtonsByPosition();
    return this;
  },

  close: function () {
    this.remove();
  },
});
