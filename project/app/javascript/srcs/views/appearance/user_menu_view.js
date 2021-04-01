import { App } from "srcs/internal";

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
  },

  initialize: function (options) {
    this.parent = options.parent;
    this.chat_bans = this.parent.chat_bans;
    this.online_users = this.parent.online_users;
    this.friends = this.parent.friends;
    this.is_friend = options.is_friend;
    this.listenTo(
      App.app_view.appearance_view,
      "destroy_user_menu_all",
      this.close
    );
    this.listenTo(window, "resize", this.close);
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

  directChat: function () {
    App.app_view.direct_chat_view.render(this.model);
    this.close();
  },

  createChatBan: function () {
    this.chat_bans.createChatBan(this.model.id);
    this.close();
  },

  destroyChatBan: function () {
    this.chat_bans.destroyChatBan(this.model.id);
    this.close();
  },

  createFriend: function () {
    this.friends.createFriendship(this.model);
    this.online_users.remove(this.model);
    this.close();
  },

  destroyFriend: function () {
    this.friends.destroyFriendship(this.model);
    this.close();
  },

  battle: function () {
    App.current_user.dualRequestTo(this.model);
    this.close();
  },

  close: function () {
    this.remove();
  },
});
