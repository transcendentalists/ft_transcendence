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
});
