import { App } from "srcs/internal";

export let AppearanceView = Backbone.View.extend({
  el: "#appearance-view",
  template: _.template($("#appearance-view-template").html()),

  events: {
    "click .logout.button ": "logout",
  },

  initialize: function () {
    this.chat_bans = new App.Collection.ChatBans();
    this.online_users = new App.Collection.Users();
    this.friends = new App.Collection.Friends();
  },

  logout: function () {
    this.$el.empty();
    App.restart();
  },

  render: function () {
    this.chat_bans.fetch();
    this.appearance_channel = new App.Channel.ConnectAppearanceChannel();
    this.notification_channel = new App.Channel.ConnectNotificationChannel();

    this.$el.empty();
    this.$el.html(this.template());

    this.friends_list_view = new App.View.FriendsListView({
      parent: this,
    });

    this.online_user_list_view = new App.View.OnlineUserListView({
      parent: this,
    });

    this.friends_list_view
      .setElement(this.$(".appearance.friends-list-view"))
      .render();

    this.online_user_list_view
      .setElement(this.$(".appearance.online-user-list-view"))
      .render();
  },

  close: function () {
    this.online_user_list_view.close();
    this.friends_list_view.close();
  },

  isFriend: function (id) {
    return this.friends.get(id) !== undefined;
  },

  updateUserList: function (user_data) {
    if (this.isFriend(user_data.id)) {
      this.friends_list_view.updateUserList(user_data);
    } else {
      this.online_user_list_view.updateUserList(user_data);
    }
  },
});
