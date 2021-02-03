export let CurrentUser = Backbone.Model.extend({
  urlRoot: "/api/users/",

  initialize: function () {
    this.is_admin = false;
  },

  reset: function () {
    this.initialize();
  },

  parse: function (response) {
    return response.user;
  },
});
