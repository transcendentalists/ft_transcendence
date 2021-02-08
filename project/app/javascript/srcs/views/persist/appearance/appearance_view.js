import { App, Helper } from "srcs/internal";
import consumer from "../../../../channels/consumer";

export let AppearanceView = Backbone.View.extend({
  el: "#appearance-view",
  template: _.template($("#appearance-view-template").html()),

  events: {
    "click .logout.button ": "logout",
  },

  initialize: function () {
    this.chat_bans = new App.Collection.ChatBans();
    this.online_users = new App.Collection.Users();
  },

  logout: function () {
    this.$el.empty();
    App.restart();
  },

  render: function () {
    console.log("appearance view render~!!");
    this.chat_bans.fetch();

    this.appearance_channel = new App.Channel.ConnectAppearanceChannel();

    this.$el.empty();
    this.$el.html(this.template());

    this.online_user_list_view = new App.View.OnlineUserListView({
      parent: this,
    });
    // this.friend_list_view = new

    this.online_user_list_view
      .setElement(this.$(".appearance.online-user-list-view"))
      .render();
  },

  close: function () {
    this.online_user_list_view.close();
    // this.remove();
  },

  updateUserStatus: function (user_data) {
    this.online_user_list_view.updateUserStatus(user_data);
  },
});
