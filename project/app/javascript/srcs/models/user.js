export let User = Backbone.Model.extend({
  urlRoot: "/api/users/",

  parse: function (response, options) {
    if (options.collection) {
      return response;
    } else {
      return response.user;
    }
  },
});
