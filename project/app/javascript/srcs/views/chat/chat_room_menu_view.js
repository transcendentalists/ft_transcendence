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
    // this.$element = $("#room-popup-menu");
    // this.chat_bans = this.parent.chat_bans;
    // this.online_users = this.parent.online_users;
    // this.friends = this.parent.friends;
    // this.is_friend = options.is_friend;
    // this.listenTo(
    //   App.appView.appearance_view,
    //   "destroy_user_menu_all",
    //   this.close
    // );
    // this.listenTo(window, "resize", this.close);
  },

  changeRoomInfo: function () {
    console.log("changeRoomInfo!");
  },

  backToChatRoomList: function () {
    App.router.navigate("#/chatrooms");
  },

  leaveFromChatRoom: function () {
    console.log("leaveFromChatRoom");
  },

  render: function () {
    this.$el.html(this.template());
    return this;
  },

  close: function () {
    this.remove();
  },
});
