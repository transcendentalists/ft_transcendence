import { App, Helper } from "srcs/internal";

export let UserMenuView = Backbone.View.extend({
  template: _.template($("#user-menu-view-template").html()),
  id: "user-menu-view",

  events: {
    mouseleave: "close",
    "click [data-event-name=direct-chat]": "directChat",
    "click [data-event-name=create-chat-ban]": "createChatBan",
    "click [data-event-name=destroy-chat-ban]": "destroyChatBan",
    "click [data-event-name=create-friend]": "createFriend",
    "click [data-event-name=destroy-friend]": "destroyFriend",
    "click [data-event-name=battle]": "battle",
    "click [data-event-name=user-ban]": "userBan",
  },

  initialize: function (options) {
    this.parent = options.parent;
    this.chat_bans = this.parent.chat_bans;
    this.online_users = this.parent.online_users;
    this.friends = this.parent.friends;
    this.is_friend = options.is_friend;
    this.listenTo(
      App.appView.appearance_view,
      "destroy_user_menu_all",
      this.close
    );
    this.listenTo(window, "resize", this.close);
  },

  directChat: function () {
    App.appView.direct_chat_view.render();
    this.close();
  },

  createChatBan: function () {
    this.chat_bans.createChatBan(this.model.get("id"));
    this.close();
  },

  destroyChatBan: function () {
    this.chat_bans.destroyChatBan(this.model.get("id"));
    this.close();
  },

  createFriend: function () {
    this.friends.createFriendship(this.model.get("id"));
    this.online_users.remove(this.model);
    this.close();
  },

  destroyFriend: function () {
    this.friends.destroyFriendship(this.model.get("id"));
    if (this.model.get("status") != "offline")
      this.online_users.add(this.model);
    this.close();
  },

  checkUserStatus: function () {
    if (App.current_user.get("status") == "playing") {
      Helper.info({
        subject: "대전 신청 불가능",
        description: "게임 중에는 대전 신청이 불가능합니다.",
      });
      return false;
    } else if (this.model.get("status") != "online") {
      Helper.info({
        subject: "대전 신청 불가능",
        description:
          this.model.get("name") +
          "님은 현재 " +
          this.model.get("status") +
          " 중입니다.",
      });
      return false;
    } else if (
      $("#invite-view").is(":visible") ||
      $("#request-view").is(":visible")
    ) {
      Helper.info({
        subject: "대전 신청 불가능",
        description: "다른 유저와 대전 신청 중에는 대전 신청이 불가능합니다.",
      });
      return false;
    }
    return true;
  },

  battle: function () {
    if (this.checkUserStatus()) {
      App.notification_channel.dualRequest(this.model.get("id"));
      App.appView.request_view.render(this.model.attributes);
    }
    this.close();
  },

  userBan: function () {
    this.close();
  },

  render: function (position) {
    this.$el.html(
      this.template({
        model: this.model,
        banned: this.chat_bans.isUserChatBanned(this.model.id),
        is_friend: this.is_friend,
      })
    );
    this.$el.css("position", "absolute");
    this.$el.css("top", position.top);
    this.$el.css("left", position.left - 127);
    this.$el.css("z-index", 103);
    return this;
  },

  close: function () {
    this.remove();
  },
});
