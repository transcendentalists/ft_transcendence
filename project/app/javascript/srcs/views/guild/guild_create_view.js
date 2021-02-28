import { App, Helper } from "srcs/internal";

export let GuildCreateView = Backbone.View.extend({
  template: _.template($("#guild-create-view-template").html()),
  warning_message_template: _.template($("#warning-message-template").html()),
  id: "guild-create-view",
  className: "create-view top-margin",

  events: {
    "click .guild-create-button": "submit",
    "click .guild-create-cancel-button": "cancel",
  },

  initialize: function () {
    this.name = null;
    this.anagram = null;
    this.image = null;
  },

  render: function () {
    this.$el.html(this.template());
    this.$(".ui.negative.message").hide();
    return this;
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

  submit: function () {
    this.parseGuildParams();
    if (this.checkValidOfParams()) this.createGuild();
  },

  parseGuildParams: function () {
    this.name = this.$("input[name=name]").val();
    this.anagram = this.$("input[name=anagram]").val();
    this.image = this.$("input[type=file]")[0].files[0];
  },

  checkValidOfParams: function () {
    if (this.image == undefined) {
      this.renderWarning("이미지가 설정되어 있지 않습니다.");
    } else if (
      !["image/png", "image/jpeg", "image/png", "image/jpg"].includes(
        this.image.type
      )
    ) {
      this.renderWarning("지원하지 않는 이미지 포맷입니다.");
    } else if (this.image.size >= 1000000) {
      this.renderWarning("이미지 사이즈가 큽니다.");
    } else {
      return true;
    }
    return false;
  },

  appendFormData() {
    let form_data = new FormData();
    form_data.append("name", this.name);
    form_data.append("anagram", this.anagram);
    form_data.append("file", this.image);
    return form_data;
  },

  createGuild: async function () {
    const form_data = this.appendFormData();
    let data = await fetch("api/guilds/", {
      method: "POST",
      headers: {
        "X-CSRF-Token": Helper.getToken(),
        current_user: App.current_user.id,
      },
      body: form_data,
    });
    let response = {};
    let success = false;
    try {
      response = await data.json();
      success = Math.floor(data.status / 100) == 2;
    } catch (err) {}

    if (success) {
      App.current_user.set("guild", response.guild);
      App.router.navigate("#/guilds/page/1");
    } else {
      Helper.info({ error: response.error });
    }
  },

  cancel: function () {
    this.close();
    App.router.navigate("#/guilds/page/1");
  },

  close: function () {
    this.remove();
  },
});
