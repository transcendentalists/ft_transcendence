import { App, Helper } from "srcs/internal";

export let UserIndexButtonsView = Backbone.View.extend({
  template: _.template($("#user-index-buttons-view-template").html()),
  events: {
    "click #two-factor-toggle": "changeTwoFactorAuth",
    "click #avatar-change-button": "showAvatarImageUploadModal",
    "click #name-change-button": "showNameInputModal",
    "click #guild-invite-button": "sendInvitationRequest",
  },

  initialize: function (user) {
    this.user_id = user.id;
    this.is_current_user = Helper.isCurrentUser(this.user_id);
    this.invite_button = this.setInviteButton(user);
  },

  setInviteButton: function (user) {
    if (this.is_current_user || user.get("guild") !== null) return false;

    const current_user_position = App.current_user.get("guild")?.position;
    return ["master", "officer"].includes(current_user_position);
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

  changeTwoFactorAuth: function () {
    const value = this.$("#two-factor-toggle input").is(":checked");
    App.current_user.two_factor_auth = value;
    Helper.fetch("users/" + this.user_id, {
      method: "PATCH",
      body: {
        user: {
          id: this.user_id,
          two_factor_auth: value,
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
    App.app_view.image_upload_modal_view.render(callback);
  },

  changeNameRequest: function (input) {
    Helper.fetch("users/" + this.user_id, {
      method: "PATCH",
      body: {
        user: {
          name: input,
        },
      },
      success_callback: () => App.router.navigate("#/"),
      fail_callback: Helper.defaultErrorHandler,
    });
  },

  showNameInputModal: function () {
    Helper.input({
      subject: "이름 변경",
      description: "변경할 이름을 입력해주세요. 이름은 고유해야 합니다.",
      success_callback: this.changeNameRequest.bind(this),
    });
  },

  sendInvitationRequest: function () {
    const invite_url = `users/${App.current_user.id}/guild_invitations`;
    Helper.fetch(invite_url, {
      method: "POST",
      body: {
        invited_user_id: this.user_id,
        guild_id: App.current_user.get("guild").id,
      },
      success_callback: Helper.defaultSuccessHandler("길드 초대"),
      fail_callback: Helper.defaultErrorHandler,
    });
  },

  close: function () {
    this.remove();
  },
});
