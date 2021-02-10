export let User = Backbone.Model.extend({
  urlRoot: "/api/users/",

  defaults: {
    isWebOwner: false,
    sign_in: false,
  },

  reset: function (isWebOwner = false) {
    this.clear();
    this.set({ isWebOwner: false, sign_in: false });
  },

  parse: function (response, options) {
    if (options.collection) {
      return response;
    } else {
      return response.user;
    }
  },
});
