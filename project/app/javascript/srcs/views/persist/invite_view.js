import { Helper } from "srcs/internal";

export let InviteView = Backbone.View.extend({
  template: _.template($("#invite-view-template").html()),
  el: "#invite-view",
  events: {
    "click .basic.button": "alert",
    "click .ui.avatar": "imageChange",
  },

  imageChange: function () {
    Helper.input();
    // Helper.input({
    //   subject: "와우!",
    //   description: "사진을 바꾸고 싶으신가봐요?",
    //   success_callback: function (data) {
    //     console.log("alert wit parameter success");
    //   },
    // });
  },

  alert: function () {
    Helper.alert({
      subject: "주의",
      description: "당신보다 강한 적일 수 있습니다.",
    });
  },

  initialize: function () {
    this.$el.hide();
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());
    this.$el.show();
  },

  close: function () {
    this.$el.hide();
  },
});
