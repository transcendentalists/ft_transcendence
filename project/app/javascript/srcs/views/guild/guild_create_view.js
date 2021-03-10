import { App, Helper } from "srcs/internal";

export let GuildCreateView = Backbone.View.extend({
  template: _.template($("#guild-create-view-template").html()),
  warning_message_template: _.template($("#warning-message-template").html()),
  id: "guild-create-view",
  className: "create-view top-margin",

  events: {
    "click .guild-create-button": "submit",
    "click .guild-create-cancel-button": "cancel",
    "click .anagram-definition-icon": "showAnagramDefinition",
  },

  initialize: function () {
    this.name = null;
    this.anagram = null;
    this.image = null;
    this.message_field = null;
    this.warning_message = null;
  },

  render: function () {
    this.$el.html(this.template());
    this.message_field = this.$(".ui.negative.message");
    this.message_field.hide();
    this.name = document.forms[0][input_name].value;
    return this;
  },

  submit: function () {
    this.parseGuildParams();
    if (this.checkValidOfImage()) this.createGuild();
    else this.renderWarning(this.warning_message);
  },

  parseGuildParams: function () {
    this.name = this.$("input[name=name]").val();
    this.anagram = this.$("input[name=anagram]").val();
    this.image = this.$("input[type=file]")[0].files[0];
  },

  checkValidOfImage: function () {
    const allowed_image_format = ["image/png", "image/jpeg", "image/jpg"];
    if (this.image === undefined) {
      this.warning_message = "이미지가 설정되어 있지 않습니다.";
    } else if (!allowed_image_format.includes(this.image.type)) {
      this.warning_message = "지원하지 않는 이미지 포맷입니다.";
    } else if (this.image.size >= 1048576) {
      this.warning_message = "이미지 사이즈는 1MB 미만여야합니다.";
    } else {
      return true;
    }
    return false;
  },

  createGuild: async function () {
    const form_data = this.appendFormData();
    Helper.fetch("guilds", {
      method: "POST",
      headers: {
        "Content-Type": "form-data",
      },
      body: form_data,
      success_callback: (data) => {
        App.current_user.set("guild", data.guild_membership);
        App.router.navigate("#/guilds?page=1");
      },
      fail_callback: Helper.defaultErrorHandler,
    });
  },

  appendFormData: function () {
    let form_data = new FormData();
    form_data.append("name", this.name);
    form_data.append("anagram", this.anagram);
    form_data.append("file", this.image);
    return form_data;
  },

  renderWarning: function (msg) {
    if (!msg) return;
    this.message_field.html(
      this.warning_message_template({
        type: "업로드 에러",
        msg: msg,
      })
    );
    this.message_field.show();
  },

  cancel: function () {
    App.router.navigate("#/guilds?page=1");
  },

  showAnagramDefinition: function () {
    Helper.info({
      subject: "아나그램이란?",
      description:
        "아나그램은 길드 이름에 포함된 글자들만을 사용하여 만들어지는 어구입니다.<br>\
        또한 아나그램은 길드 이름보다 같거나 짧아야 합니다.",
    });
  },

  close: function () {
    this.remove();
  },
});
