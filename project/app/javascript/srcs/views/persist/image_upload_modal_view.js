import { Helper } from "srcs/internal";

export let ImageUploadModalView = Backbone.View.extend({
  template: _.template($("#image-upload-modal-view-template").html()),
  warning_message_template: _.template($("#warning-message-template").html()),
  el: "#image-upload-modal-view",
  events: { "click .upload.button": "uploadFile" },

  initialize: function () {
    this.uploadCallback = null;
  },

  renderWarning: function (msg) {
    this.$(".ui.negative.message").html(
      this.warning_message_template({
        type: "업로드 에러",
        msg: msg,
      })
    );
    this.$(".ui.negative.message").show();
  },

  uploadFile: function () {
    const image = this.$("input[type=file]")[0].files[0];
    if (image == undefined) {
      this.renderWarning("이미지가 설정되어 있지 않습니다.");
    } else if (image.size >= 1000000) {
      this.renderWarning("이미지 사이즈가 큽니다.");
    } else if (!["image/png", "image/jpeg", "image/png"].includes(image.type)) {
      this.renderWarning("지원하지 않는 이미지 포맷입니다.");
    } else {
      const formData = new FormData();
      formData.append("file", image);
      this.uploadCallback(formData);
      this.close();
    }
  },

  render: function (upload_callback) {
    this.upload_callback = upload_callback;
    this.$el.html(this.template());
    $("#image-upload-modal-view.tiny.modal").modal("show");
    this.$(".ui.negative.message").hide();
    return this;
  },

  close: function () {
    this.$el.empty();
    $("#image-upload-modal-view.tiny.modal").modal("hide");
  },
});
