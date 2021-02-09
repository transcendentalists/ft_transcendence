import { App } from "srcs/internal";

export let UserMenuView = Backbone.View.extend({
  template: _.template($("#user-menu-view-template").html()),
  id: "user-menu-view",

  events: {
    mouseleave: "close",
    "click [data-event-name=direct-chat]": "directChat",
    "click [data-event-name=create-chat-ban]": "createChatBan",
    "click [data-event-name=destroy-chat-ban]": "destroyChatBan",
    "click [data-event-name=new-friend]": "newFriend",
    "click [data-event-name=battle]": "battle",
    "click [data-event-name=user-ban]": "userBan",
  },

  initialize: function (options) {
    this.parent = options.parent;
    this.chat_bans = this.parent.chat_bans;
    this.online_users = this.parent.online_users;
    this.friends = this.parent.friends;

    this.listenTo(this.online_users, "destroy_user_menu_all", this.close);
    this.listenTo(this.friends, "destroy_user_menu_all", this.close);
    this.listenTo(window, "resize", this.close);
  },

  directChat: function () {
    App.appView.direct_chat_view.render();
    console.log("directChat!!");
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

  newFriend: function () {
    // this.model
    console.log("newFriend!!");
    // this.close();
  },

  battle: function () {
    // this.model
    console.log("battle!!");
    // this.close();
  },

  userBan: function () {
    // this.model
    console.log("userBan!!");
    // this.close();
  },

  render: function (position) {
    this.$el.html(
      this.template({
        model: this.model,
        banned: this.chat_bans.isUserChatBanned(this.model.id),
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
