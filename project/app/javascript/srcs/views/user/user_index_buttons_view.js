import { App } from "srcs/internal";
import { Helper } from "srcs/helper";

export let UserIndexButtonsView = Backbone.View.extend({
  el: "user-index-buttons-view",
  template: _.template($("#user-index-buttons-view-template").html()),
  events: {
    "click #two-factor-toggle": "changeTwoFactorAuth",
    "click #avatar-change-button": "showAvatarImageUploadModal",
    "click #name-change-button": "showNameInputModal",
    "click #guild-invite-button": "inviteGuild",
  },

  changeTwoFactorAuth: function () {
    const after_value = this.$("#two-factor-toggle input").is(":checked");
    console.log(after_value);
    Helper.fetch("users/" + this.user_id, {
      method: "PATCH",
      body: {
        user: {
          id: this.user_id,
          two_factor_auth: after_value,
        },
      },
    });
  },

  showAvatarImageUploadModal: function () {
    let callback = function (formData) {
      formData.append("user", JSON.stringify({ id: this.user_id }));
      formData.append("has_file", JSON.stringify(true));
      fetch("api/users/" + this.user_id, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": Helper.getToken(),
        },
        body: formData,
      }).then(() => App.router.navigate("#/"));
    }.bind(this);
    App.appView.image_upload_modal_view.render(callback);
  },

  showNameInputModal: function () {
    let callback = function (input) {
      Helper.fetch("users/" + this.user_id, {
        method: "PATCH",
        body: {
          user: {
            name: input,
          },
        },
        success_callback: function () {
          App.router.navigate("#/");
        },
        fail_callback: function () {
          Helper.info({
            subject: "변경 실패",
            description:
              "이름은 공백이 아니며 고유해야 합니다. 다른 이름으로 다시 시도해주세요.",
          });
        },
      });
    }.bind(this);

    Helper.input({
      subject: "이름 변경",
      description: "변경할 이름을 입력해주세요. 이름은 고유해야 합니다.",
      success_callback: callback,
    });
  },

  inviteGuild: function () {},

  initialize: function (user_id) {
    this.user_id = user_id;
    const guild = App.current_user.get("guild");
    this.is_current_user = Helper.isCurrentUser(user_id);
    this.invite_possible =
      !this.is_current_user && guild != null && guild.position != "member";
  },

  render: function () {
    this.$el.html(
      this.template({
        is_current_user: this.is_current_user,
        invite_possible: this.invite_possible,
      })
    );
    if (App.current_user.two_factor_auth)
      this.$("#two-factor-toggle input").trigger("click");
    return this;
  },

  close: function () {
    this.remove();
  },
});
