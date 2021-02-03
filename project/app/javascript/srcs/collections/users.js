import { User } from "../models/user";

export let Users = Backbone.Collection.extend({
  url: "/api/users/",
  model: User,
  parse: function (response) {
    return response.users;
  },
  sanam: function () {
    return this.where({ name: "sanam" });
  },
  jujeong: function () {
    return this.where({ name: "jujeong" });
  },
  iwoo: function () {
    return this.where({ name: "iwoo" });
  },
  eunhkim: function () {
    return this.where({ name: "eunhkim" });
  },
  yohlee: function () {
    return this.where({ name: "yohlee" });
  },
});
