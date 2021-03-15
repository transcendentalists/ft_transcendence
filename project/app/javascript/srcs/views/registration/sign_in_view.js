import { App, Helper } from "srcs/internal";

/**
 ** 2차 인증이 활성화되어 있다면 email을 통한 2차인증 번호 입력 필요
 ** process: login(must) -> verification(optional)
 */
export let SignInView = Backbone.View.extend({
  id: "sign-in-view",
  template: _.template($("#sign-in-view-template").html()),
  warning_message_template: _.template($("#warning-message-template").html()),
  events: {
    "click .button": "submit",
  },

  initialize: function () {
    this.status = null;
    this.current_user_id = null;
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());

    this.status = "login";
    this.login_field = this.$(".login.field");
    this.submit_button = this.$(".submit.button");

    this.auth_field = this.$(".auth.field");
    this.auth_field.hide();
    this.message_field = this.$(".ui.negative.message");
    this.message_field.hide();

    return this;
  },

  submit: function () {
    if (this.submit_button.hasClass("disabled")) return;
    this.submit_lock();

    switch (this.status) {
      case "login":
        let name = this.getInput("name");
        let password = this.getInput("password");
        this.signInRequest(name, password);
        break;
      case "auth":
        let verification_code = this.getInput("auth");
        this.authRequest(verification_code);
        break;
    }
  },

  getInput: function (input_name) {
    return document.forms[0][input_name].value;
  },

  signInRequest: function (name, password) {
    Helper.fetch(`users/${name}/session`, this.signInParams(name, password));
  },

  signInParams: function (name, password) {
    return {
      method: "POST",
      success_callback: this.signInSuccessCallback.bind(this),
      fail_callback: this.showWarningMessage.bind(this),
      body: {
        user: {
          name,
          password,
        },
      },
    };
  },

  signInSuccessCallback: function (data) {
    this.current_user_id = data.current_user.id;
    App.current_user.two_factor_auth = data.current_user.two_factor_auth;
    if (data.current_user.two_factor_auth) {
      this.status = "auth";
      this.submit_unlock();
      this.login_field.hide();
      this.auth_field.show();
    } else this.authSuccessCallback(data);
  },

  showWarningMessage: function (data) {
    const message_hash = {
      401: "입력하신 비밀번호가 일치하지 않습니다.",
      403: "로그인이 금지되었습니다, 관리자에게 문의해주세요.",
      404: "ID를 찾을 수 없습니다.",
    };

    this.message_field.empty();
    this.message_field.append(
      this.warning_message_template({
        type: "로그인 실패",
        msg: message_hash[data.error?.code] || "잠시 후 다시 시도해주세요.",
      })
    );
    this.message_field.show();
    this.submit_unlock();
  },

  authRequest: function (verification_code) {
    Helper.fetch(
      "auth/mail/callback",
      this.authParams(this.current_user_id, verification_code)
    );
  },

  authParams: function (id, verification_code) {
    return {
      method: "POST",
      success_callback: this.authSuccessCallback.bind(this),
      fail_callback: this.showWarningMessage.bind(this),
      prefix: "",
      body: {
        user: {
          id,
          verification_code,
        },
      },
    };
  },

  authSuccessCallback: function (data) {
    App.current_user.login(data.current_user.id);
  },

  submit_lock: function () {
    if (!this.submit_button || this.submit_button.hasClass("disabled")) return;
    this.submit_button.addClass("disabled");
  },

  submit_unlock: function () {
    if (!this.submit_button || !this.submit_button.hasClass("disabled")) return;
    this.submit_button.removeClass("disabled");
  },

  close: function () {
    this.remove();
  },
});
