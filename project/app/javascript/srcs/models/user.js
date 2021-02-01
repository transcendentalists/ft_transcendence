export let User = Backbone.Model.extend({
  urlRoot: "/api/users/",

  defaults: {
    isWebOwner: false,
    signed_in: false,
  },

  parse: function (response, options) {
    if (options.collection) {
      return response;
    } else {
      return response.user;
    }
  },
});
