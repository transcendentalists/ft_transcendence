export let CurrentUser = Backbone.Model.extend({
  urlRoot: "/api/users/",

  initialize: function () {
    this.is_admin = false;
    this.sign_in = false;
  },

  login: function () {
    this.sign_in = true;
    this.fetch();
  },

  logout: function () {
    this.is_admin = false;
    this.sign_in = false;
  },

  parse: function (response) {
    return response.user;
  },
});
