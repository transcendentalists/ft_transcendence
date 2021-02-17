import { App, Helper } from "../internal";
import { User } from "../models/user";

export let Friends = Backbone.Collection.extend({
  model: User,

  url: function () {
    return `/api/users/${App.current_user.id}/friendships`;
  },

  parse: function (response) {
    return response.friendships;
  },

  createFriendship: function (model) {
    this.user_model = model;
    Helper.fetch(
      `users/${App.current_user.id}/friendships`,
      this.createFriendshipParams(model)
    );
  },

  createFriendshipParams: function (model) {
    return {
      method: "POST",
      success_callback: this.addFriend.bind(this),
      body: {
        friend_id: model.id,
      },
    };
  },

  addFriend: function () {
    this.add(this.user_model);
  },

  destroyFriendship: function (model) {
    this.user_model = model;
    Helper.fetch(
      `users/${App.current_user.id}/friendships/${model.id}`,
      this.destroyFriendshipParams()
    );
  },

  destroyFriendshipParams: function () {
    return {
      method: "DELETE",
      success_callback: this.removeFriend.bind(this),
    };
  },

  removeFriend: function () {
    this.remove(this.user_model);
    if (this.user_model.get("status") != "offline") {
      App.appView.appearance_view.online_users.add(this.user_model);
    }
  },
});
