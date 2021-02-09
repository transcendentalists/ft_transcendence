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

  createFriendship: function(friend_id) {
    console.log("create Friend!!");
    Helper.fetch(
      `users/${App.current_user.id}/friendships`,
      this.createFriendshipParams(friend_id)
    );
  },

  createFriendshipParams: function (friend_id) {
    return {
      method: "POST",
      success_callback: this.fetchFriends.bind(this),
      body: {
        friend_id: friend_id,
      },
    };
  },

  fetchFriends: function() {
    this.fetch({reset: true});
  },

  destroyFriendship: function (friend_id) {
    Helper.fetch(
      `users/${App.current_user.id}/friendships/${friend_id}`,
      this.destroyFriendshipParams()
    );
  },

  destroyFriendshipParams: function () {
    return {
      method: "DELETE",
      success_callback: this.fetchFriends.bind(this),
    };
  },
});
