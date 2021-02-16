import { App } from "srcs/internal";
import { Helper } from "srcs/helper";

export let ChatRoomMemberMenuView = Backbone.View.extend({
  template: _.template($("#chat-room-member-menu-view-template").html()),

  events: {
    // "click [data-event-name=direct-chat]": "directChat",
    // "click [data-event-name=create-chat-ban]": "createChatBan",
    // "click [data-event-name=destroy-chat-ban]": "destroyChatBan",
    // "click [data-event-name=create-friend]": "createFriend",
    // "click [data-event-name=destroy-friend]": "destroyFriend",
    // "click [data-event-name=battle]": "battle",
    // "click [data-event-name=user-ban]": "userBan",
  },

  initialize: function (options) {
    this.parent = options.parent;
    this.$element = $("#room-popup-menu");
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

  // directChat: function () {
  //   App.appView.direct_chat_view.render(this.model);
  //   this.close();
  // },

  // createChatBan: function () {
  //   this.chat_bans.createChatBan(this.model.get("id"));
  //   this.close();
  // },

  // destroyChatBan: function () {
  //   this.chat_bans.destroyChatBan(this.model.get("id"));
  //   this.close();
  // },

  // createFriend: function () {
  //   this.friends.createFriendship(this.model.get("id"));
  //   this.online_users.remove(this.model);
  //   this.close();
  // },

  // destroyFriend: function () {
  //   this.friends.destroyFriendship(this.model.get("id"));
  //   if (this.model.get("status") != "offline")
  //     this.online_users.add(this.model);
  //   this.close();
  // },

  // battle: function () {
  //   this.close();
  // },

  // userBan: function () {
  //   this.close();
  // },

  render: function (options) {
    console.log(options);
    console.log(this);

    const user = options.user;
    this.$element.html(
      this.template({
        user: options.user,
        current_user_position: this.parent.chat_room_members.get(
          App.current_user.id
        ).position,
        banned: Helper.isUserChatBanned(user.id),
        is_friend: Helper.isUserFriend(user.id),
      })
    );
    this.$element.css("position", "fixed");
    this.$element.css("top", options.client_y);
    this.$element.css("left", options.client_x);
    this.$element.css("z-index", 103);
    this.$element.css("display", "block");
    return this;
  },

  hide: function () {
    this.$el.css("display", "none");
  },

  close: function () {
    this.$el.empty();
  },
});
