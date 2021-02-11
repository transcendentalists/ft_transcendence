import { App, Helper } from "srcs/internal";

export let SignInView = Backbone.View.extend({
  id: "sign-in-view",
  template: _.template($("#sign-in-view-template").html()),
  warning_message_template: _.template($("#warning-message-template").html()),
  events: {
    "click .button": "submit",
  },

  initialize: function () {
    this.current_user_id = null;
    this.two_factor_auth = false;
    this.verification_code = null;
  },

  signInParams: function (name, password) {
    return {
      method: "POST",
      success_callback: this.loginSuccessCallback.bind(this),
      fail_callback: this.failCallback.bind(this),
      body: {
        user: {
          name,
          password,
        },
      },
    };
  },

  authParams: function (id, verification_code) {
    return {
      method: "POST",
      success_callback: this.authSuccessCallback.bind(this),
      fail_callback: this.failCallback.bind(this),
      prefix: "",
      body: {
        user: {
          id,
          verification_code,
        },
      },
    };
  },

  loginSuccessCallback: function (data) {
    this.current_user_id = data.current_user.id;
    if (data.current_user.two_factor_auth) {
      this.$(".login.field").hide();
      this.$(".auth.field").show();
      this.two_factor_auth = true;
    } else this.authSuccessCallback(data);
  },

  authSuccessCallback: function (data) {
    App.current_user.set("id", data.current_user.id);
    App.current_user.login();
    App.appView.render();
    App.router.navigate(`#/users/${data.current_user.id}`);
  },

  failCallback: function (data) {
    this.$(".ui.negative.message").empty();
    this.$(".ui.negative.message").append(
      this.warning_message_template(data.error)
    );
    this.$(".ui.negative.message").show();
  },

  submit: function () {
    if (!this.two_factor_auth) {
      let name = $("input[name=name]").val();
      let password = $("input[name=password]").val();
      Helper.fetch(`users/${name}/session`, this.signInParams(name, password));
    } else {
      let verification_code = $("input[name=auth]").val();

      Helper.fetch(
        "auth/mail/callback",
        this.authParams(this.current_user_id, verification_code)
      );
    }
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());
    this.$(".auth.field").hide();
    this.$(".ui.negative.message").hide();
    this.status = "LOGIN";
    return this;
  },

  close: function () {
    this.remove();
  },
});
