import { App, Helper } from "srcs/internal";

export let SignUpView = Backbone.View.extend({
  id: "sign-up-view",
  template: _.template($("#sign-up-view-template").html()),
  warning_message_template: _.template($("#warning-message-template").html()),
  events: {
    "click .button": "submit",
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());

    this.message_field = this.$(".ui.negative.message");
    this.message_field.hide();

    return this;
  },

  submit: function () {
    let name = this.getInput("name");
    let password = this.getInput("password");
    let email = this.getInput("email");

    Helper.fetch("users", this.signUpParams(name, password, email));
  },

  getInput: function (input_name) {
    return document.forms[0][input_name].value;
  },

  signUpParams: function (name, password, email) {
    return {
      method: "POST",
      success_callback: this.signUpSuccessCallback.bind(this),
      fail_callback: this.showWarningMessage.bind(this),
      body: {
        user: {
          name,
          email,
          password,
        },
      },
    };
  },

  signUpSuccessCallback: function (data) {
    App.current_user.login(data.user.id);
  },

  showWarningMessage: function (data) {
    this.message_field.empty();
    this.message_field.append(this.warning_message_template(data.error));
    this.message_field.show();
  },

  close: function () {
    this.remove();
  },
});
