export let User = Backbone.Model.extend({
  urlRoot: "/api/users/",

  parse: function (response, options) {
    if (options.collection) {
      window.aaa = options;

      return response;
    } else {
      return response.user;
    }
  },
});
