import { App } from "srcs/internal";

(function () {
  var backboneSync = Backbone.sync;

  Backbone.sync = function (method, model, options) {
    options.headers = {
      current_user: App.current_user.id,
    };

    backboneSync(method, model, options);
  };

  Backbone.Model.prototype.equalTo = function (other) {
    return _.isEqual(this.id, other.id);
  };
})();
