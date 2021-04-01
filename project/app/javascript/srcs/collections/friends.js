import { App, Helper } from "srcs/internal";
import { User } from "srcs/models/user";

export let Friends = Backbone.Collection.extend({
  model: User,

  url: function () {
    return `/api/users/${App.current_user.id}/friendships`;
  },

  parse: function (response) {
    return response.friendships;
  },

  createFriendship: function (user_model) {
    this.user_model = user_model;
    Helper.fetch(
      `users/${App.current_user.id}/friendships`,
      this.createFriendshipParams(user_model)
    );
  },

  createFriendshipParams: function (user_model) {
    return {
      method: "POST",
      success_callback: this.addFriend.bind(this),
      body: {
        friend_id: user_model.id,
      },
    };
  },

  addFriend: function () {
    this.add(this.user_model);
  },

  destroyFriendship: function (user_model) {
    this.user_model = user_model;
    Helper.fetch(
      `users/${App.current_user.id}/friendships/${user_model.id}`,
      this.destroyFriendshipParams()
    );
  },

  destroyFriendshipParams: function () {
    return {
      method: "DELETE",
      success_callback: this.removeFriendAndAddToOnlineUsers.bind(this),
    };
  },

  removeFriendAndAddToOnlineUsers: function () {
    this.remove(this.user_model);
    if (this.user_model.get("status") != "offline") {
      App.app_view.appearance_view.online_users.add(this.user_model);
    }
  },
});
