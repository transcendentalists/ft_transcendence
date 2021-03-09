import { App, Helper } from "srcs/internal";

export let SignUpView = Backbone.View.extend({
  id: "sign-up-view",
  template: _.template($("#sign-up-view-template").html()),
  warning_message_template: _.template($("#warning-message-template").html()),
  events: {
    "click .button": "submit",
  },

  signUpSuccessCallback: function (data) {
    App.current_user.set("id", data.user.id);
    App.current_user.login();
    App.app_view.render();
    App.router.navigate(`#/users/${data.user.id}`);
  },

  failCallback: function (data) {
    this.$(".ui.negative.message").empty();
    this.$(".ui.negative.message").append(
      this.warning_message_template(data.error)
    );
    this.$(".ui.negative.message").show();
  },

  signUpParams: function (name, password, email) {
    return {
      method: "POST",
      success_callback: this.signUpSuccessCallback.bind(this),
      fail_callback: this.failCallback.bind(this),
      body: {
        user: {
          name,
          email,
          password,
        },
      },
    };
  },

  submit: function () {
    let name = $("input[name=name]").val();
    let password = $("input[name=password]").val();
    let email = $("input[name=email]").val();

    Helper.fetch("users", this.signUpParams(name, password, email));
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());
    this.$(".ui.negative.message").hide();
    return this;
  },

  close: function () {
    this.remove();
  },
});
