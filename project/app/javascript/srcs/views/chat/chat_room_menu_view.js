import { App } from "srcs/internal";
import { Helper } from "srcs/helper";

export let ChatRoomMenuView = Backbone.View.extend({
  template: _.template($("#chat-room-menu-view-template").html()),

  events: {
    "click [data-event-name=change-room-info]": "changeRoomInfo",
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

  changeRoomInfo: function () {
    console.log("changeRoomInfo!");
  },

  backToChatRoomList: function () {
    App.router.navigate("#/chatrooms");
  },

  leaveFromChatRoom: function () {
    this.chat_room_members.letOutOfChatRoom(this.current_user_as_room_member);
    App.router.navigate("#/");
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
