/*
 * error_code: [subject, description] 형식으로 정의
 * 어디에서든 App.router.navigate(error_code)로 리다이렉트 가능
 */

import { App } from "srcs/internal";

export let ErrorView = Backbone.View.extend({
  template: _.template($("#error-view-template").html()),
  id: "error-view",
  events: {
    "click .button": "redirect_home",
  },

  redirect_home: function () {
    App.router.navigate("#/users/" + App.current_user.id);
  },

  // TODO: 100번대 에러코드를 실제와 맞게 셋팅
  initialize: function (error_hash) {
    this.error_set = {
      100: ["Undefined Route", "정의되지 않은 에러입니다."],
      101: ["Route Error", "요청하신 War 페이지를 찾을 수 없습니다."],
      102: ["Route Error", "요청하신 Tournament 페이지를 찾을 수 없습니다."],
      103: ["Unauthorized", "Admin 권한이 없습니다."],
      104: ["Route Error", "요청하신 Admin 페이지를 찾을 수 없습니다."],
      105: ["Create Failed", "요청하신 ChatRoom을 만들 수 없습니다."],
      106: ["Input not entered", "아무런 정보가 입력되지 않았습니다."],

      400: ["Bad Request", "부정확한 요청입니다."],
      403: ["Invalid Authorization", "접근할 권한이 없습니다."],
      404: ["Not Found", "요청하신 리소스를 찾을 수 없습니다."],

      500: ["Server Error", "잠시 후 다시 시도해주세요."],
    };

    this.error_hash = error_hash;
    this.error_code = error_hash.error_code;
    if (!this.error_set.hasOwnProperty(this.error_code))
      this.error_code = "100";
  },

  to_json: function () {
    let data = this.error_set[this.error_code];

    return {
      code: this.error_code,
      subject: this.error_hash.type || data[0],
      description: this.error_hash.msg || data[1],
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
