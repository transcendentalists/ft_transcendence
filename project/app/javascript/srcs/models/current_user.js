export let CurrentUser = Backbone.Model.extend({
  urlRoot: "/api/users/",

  initialize: function () {
    this.is_admin = false;
    this.sign_in = false;
  },

  logout: function () {
    this.is_admin = false;
    this.sign_in = false;
  },

  parse: function (response) {
    return response.user;
  },

  login: function () {
    this.sign_in = true;
    this.fetch({
      data: { for: "profile" },
    });
  },

  getGuildId: function () {
    return this.get("guild") ? this.get("guild").id : null;
  },

  getGuildPosition: function () {
    return this.get("guild") ? this.get("guild").position : null;
  },
});
