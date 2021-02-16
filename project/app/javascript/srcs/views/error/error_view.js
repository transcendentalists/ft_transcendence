/*
 * error_code: [subject, description] 형식으로 정의
 * 어디에서든 App.router.navigate(error_code)로 리다이렉트 가능
 */

import { App } from "../../internal";

export let ErrorView = Backbone.View.extend({
  template: _.template($("#error-view-template").html()),
  id: "error-view",
  events: {
    "click .button": "redirect_home",
  },

  redirect_home: function () {
    App.router.navigate("#/users/" + App.current_user.id);
  },

  initialize: function (error_code) {
    this.error_hash = {
      100: ["Undefined Route", "정의되지 않은 에러입니다."],
      101: ["Route Error", "요청하신 War 페이지를 찾을 수 없습니다."],
      102: ["Route Error", "요청하신 Tournament 페이지를 찾을 수 없습니다."],
      103: ["Unauthorized", "Admin 권한이 없습니다."],
      104: ["Route Error", "요청하신 Admin 페이지를 찾을 수 없습니다."],
      105: ["Create Failed", "요청하신 ChatRoom을 만들 수 없습니다."],
      106: ["Input not entered", "아무런 정보가 입력되지 않았습니다."],

      403: ["Invalid Authorization", "인증 정보가 일치하지 않습니다."],
      404: ["Not Found", "요청하신 리소스를 찾을 수 없습니다."],

      500: ["Server Error", "잠시 후 다시 시도해주세요."],
    };

    this.error_code = error_code;
    if (!this.error_hash.hasOwnProperty(this.error_code))
      this.error_code = "100";
  },

  to_json: function () {
    let data = this.error_hash[this.error_code];

    return {
      code: this.error_code,
      subject: data[0],
      description: data[1],
    };
  },

  render: function () {
    this.$el.html(this.template(this.to_json()));
    return this;
  },

  close: function () {
    this.remove();
  },
});
