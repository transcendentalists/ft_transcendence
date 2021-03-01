import { App, Helper } from "srcs/internal";

export let WarCreateView = Backbone.View.extend({
  template: _.template($("#war-create-view-template").html()),
  warning_message_template: _.template($("#warning-message-template").html()),
  id: "war-create-view",
  className: "create-view top-margin",

  events: {
    "click .war-create-button": "submit",
    "click .war-create-cancel-button": "cancel",
  },

  initialize: function () {
    this.opponent_guild_id = Helper.parseHashQuery().enemy_id;
  },

  submit: function () {
    this.parseWarParams();
    // if (this.checkValidOfParams()) this.createWar();
  },

  parseWarParams: function () {
    let input_data = {};
    input_data["bet_point"] = +$(".bet-point option:selected").val();
    input_data["war_start_date"] = $(".war-start-date option:selected").val();
    input_data["war_duration"] = $(".war-duration option:selected").val();
    input_data["war_time"] = $(".war-time option:selected").val();
    input_data["max_no_reply_count"] = $(
      ".max-no-reply-count option:selected"
    ).val();
    input_data["rule"] = $(".rule option:selected").val();
    input_data["include_ladder"] = $(".include-ladder option:selected").val();
    input_data["include_tournament"] = $(
      ".include-tournament option:selected"
    ).val();

    console.log(input_data);
  },

  // checkValidOfParams: function () {
  //   if (this.image == undefined) {
  //     this.renderWarning("이미지가 설정되어 있지 않습니다.");
  //   } else if (
  //     !["image/png", "image/jpeg", "image/png", "image/jpg"].includes(
  //       this.image.type
  //     )
  //   ) {
  //     this.renderWarning("지원하지 않는 이미지 포맷입니다.");
  //   } else if (this.image.size >= 1000000) {
  //     this.renderWarning("이미지 사이즈가 큽니다.");
  //   } else {
  //     return true;
  //   }
  //   return false;
  // },

  // renderWarning: function (msg) {
  //   this.$(".ui.negative.message").html(
  //     this.warning_message_template({
  //       type: "업로드 에러",
  //       msg: msg,
  //     })
  //   );
  //   this.$(".ui.negative.message").show();
  // },

  // createWar: async function () {
  //   const form_data = this.appendFormData();
  //   let data = await fetch("api/guilds/", {
  //     method: "POST",
  //     headers: {
  //       "X-CSRF-Token": Helper.getToken(),
  //       current_user: App.current_user.id,
  //     },
  //     body: form_data,
  //   });
  //   let response = {};
  //   let success = false;
  //   try {
  //     response = await data.json();
  //     success = Math.floor(data.status / 100) == 2;
  //   } catch (err) {}

  //   if (success) {
  //     App.current_user.set("guild", response.guild);
  //     App.router.navigate("#/guilds?page=1");
  //   } else {
  //     Helper.info({ error: response.error });
  //   }
  // },

  // appendFormData() {
  //   let form_data = new FormData();
  //   form_data.append("name", this.name);
  //   form_data.append("anagram", this.anagram);
  //   form_data.append("file", this.image);
  //   return form_data;
  // },

  cancel: function () {
    this.close();
    App.router.navigate("#/guilds?page=1");
  },

  render: function () {
    this.$el.html(
      this.template({
        opponent_guild_name: "GON",
        tomorrow: 1,
      })
    );
    this.$(".ui.negative.message").hide();
    return this;
  },

  close: function () {
    this.remove();
  },
});
