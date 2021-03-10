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
  },

  submit: function () {
    this.parseGuildParams();
    if (this.checkValidOfImage()) this.createGuild();
  },

  parseGuildParams: function () {
    this.name = this.$("input[name=name]").val();
    this.anagram = this.$("input[name=anagram]").val();
    this.image = this.$("input[type=file]")[0].files[0];
  },

  checkValidOfImage: function () {
    let warning_message = null;
    const allowed_image_format = ["image/png", "image/jpeg", "image/jpg"];
    if (this.image === undefined) {
      warning_message = "이미지가 설정되어 있지 않습니다.";
    } else if (!allowed_image_format.includes(this.image.type)) {
      warning_message = "지원하지 않는 이미지 포맷입니다.";
    } else if (this.image.size >= 1048576) {
      warning_message = "이미지 사이즈는 1MB 미만여야합니다.";
    } else {
      return true;
    }
    this.renderWarning(warning_message);
    return false;
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

  render: function () {
    this.$el.html(this.template());
    this.$(".ui.negative.message").hide();
    return this;
  },

  close: function () {
    this.remove();
  },
});
