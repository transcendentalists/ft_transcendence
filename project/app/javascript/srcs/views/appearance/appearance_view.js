import { App } from "srcs/internal";

export let AppearanceView = Backbone.View.extend({
  el: "#appearance-view",
  template: _.template($("#appearance-view-template").html()),

  initialize: function () {
    this.chat_bans = App.resources.chat_bans;
    this.online_users = new App.Collection.Users();
    this.friends = new App.Collection.Friends();
  },

  renderFriendListView: function () {
    this.friends_list_view = new App.View.FriendsListView({
      parent: this,
    });
    this.friends_list_view
      .setElement(this.$(".appearance.friends-list-view"))
      .render();
  },

  renderOnlineUserListView: function () {
    this.online_user_list_view = new App.View.OnlineUserListView({
      parent: this,
    });
    this.online_user_list_view
      .setElement(this.$(".appearance.online-user-list-view"))
      .render();
  },

  renderMainButtonsView: function () {
    this.main_buttons_view = new App.View.MainButtonsView();
    this.main_buttons_view.render({
      position: App.current_user.get("position"),
    });
  },

  render: function () {
    this.chat_bans.fetch();
    this.appearance_channel = App.Channel.ConnectAppearanceChannel();
    this.$el.html(this.template());

    this.renderFriendListView();
    this.renderOnlineUserListView();
    this.renderMainButtonsView();
  },

  close: function () {
    this.online_user_list_view.close();
    this.friends_list_view.close();
    this.main_buttons_view.close();
    this.$el.empty();
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