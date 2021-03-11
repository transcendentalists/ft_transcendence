export let ImageUploadModalView = Backbone.View.extend({
  template: _.template($("#image-upload-modal-view-template").html()),
  warning_message_template: _.template($("#warning-message-template").html()),
  el: "#image-upload-modal-view",
  events: { "click .upload.button": "uploadFile" },

  initialize: function () {
    this.upload_callback = null;
    this.message_field = null;
    this.upload_modal_view = null;
  },

  render: function (upload_callback) {
    this.upload_callback = upload_callback;
    this.$el.html(this.template());

    this.upload_modal_view = "#image-upload-modal-view.tiny.modal";
    $(this.upload_modal_view).modal("show");
    this.message_field = this.$(".ui.negative.message");
    this.message_field.hide();
    return this;
  },

  uploadFile: function () {
    const image = this.$("input[type=file]")[0].files[0];
    if (image === undefined) {
      this.renderWarning("이미지가 설정되어 있지 않습니다.");
    } else if (!["image/png", "image/jpeg", "image/png"].includes(image.type)) {
      this.renderWarning("지원하지 않는 이미지 포맷입니다.");
    } else if (image.size >= 1000000) {
      this.renderWarning("이미지 사이즈가 큽니다.");
    } else {
      const formData = new FormData();
      formData.append("file", image);
      this.upload_callback(formData);
      this.close();
    }
  },

  renderWarning: function (msg) {
    this.message_field.html(
      this.warning_message_template({
        type: "업로드 에러",
        msg: msg,
      })
    );
    this.message_field.show();
  },

  close: function () {
    this.$el.empty();
    $(this.upload_modal_view).modal("hide");
  },
});
