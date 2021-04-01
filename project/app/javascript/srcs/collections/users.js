import { User } from "srcs/models/user";

export let Users = Backbone.Collection.extend({
  url: "/api/users/",
  model: User,

  initialize: function (users = []) {
    if (users.length == 0) return;
    users.forEach((user) => this.add(new User(user)));
  },

  parse: function (response) {
    return response.users;
  },
});
