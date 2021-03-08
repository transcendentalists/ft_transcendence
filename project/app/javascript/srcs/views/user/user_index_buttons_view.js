import { App, Helper } from "srcs/internal";

export let UserIndexButtonsView = Backbone.View.extend({
  el: "user-index-buttons-view",
  template: _.template($("#user-index-buttons-view-template").html()),
  events: {
    "click #two-factor-toggle": "changeTwoFactorAuth",
    "click #avatar-change-button": "showAvatarImageUploadModal",
    "click #name-change-button": "showNameInputModal",
    "click #guild-invite-button": "inviteGuild",
  },

  initialize: function (user) {
    this.user_id = user.id;
    this.is_current_user = Helper.isCurrentUser(this.user_id);
    this.invite_button = this.canInvite(user);
  },

  canInvite: function (user) {
    const current_user_guild = App.current_user.get("guild");
    return (
      !this.is_current_user &&
      current_user_guild != null &&
      current_user_guild.position != "member" &&
      user.get("guild") == null
    );
  },

  changeTwoFactorAuth: function () {
    const after_value = this.$("#two-factor-toggle input").is(":checked");
    App.current_user.two_factor_auth = after_value;
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
      Helper.fetch("users/" + this.user_id, {
        method: "PATCH",
        headers: {
          "Content-Type": "form-data",
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

  inviteGuild: function () {
    const invite_url = `users/${App.current_user.id}/guild_invitations`;
    Helper.fetch(invite_url, {
      method: "POST",
      body: {
        invited_user_id: this.user_id,
        guild_id: App.current_user.get("guild").id,
      },
      success_callback: (data) => {
        Helper.info({
          subject: "길드 초대 성공",
          description: "초대장을 전송했습니다.",
        });
      },
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    });
  },

  render: function () {
    this.$el.html(
      this.template({
        is_current_user: this.is_current_user,
        invite_button: this.invite_button,
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
