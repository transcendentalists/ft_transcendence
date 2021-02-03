/*
 * error_code: [subject, description] 형식으로 정의
 * 어디에서든 App.router.navigate(error_code)로 리다이렉트 가능
 */

export let ErrorView = Backbone.View.extend({
  template: _.template($("#error-view-template").html()),
  id: "error-view",

  initialize: function (error_code) {
    this.error_hash = {
      100: ["Undefined Route", "정의되지 않은 에러입니다."],
      101: ["Route Error", "요청하신 War 페이지를 찾을 수 없습니다."],
      102: ["Route Error", "요청하신 Tournament 페이지를 찾을 수 없습니다."],
      103: ["Unauthorized", "Admin 권한이 없습니다."],
      104: ["Route Error", "요청하신 Admin 페이지를 찾을 수 없습니다."],
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
