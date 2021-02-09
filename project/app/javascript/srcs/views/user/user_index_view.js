import { App } from "srcs/internal";
import { Helper } from "../../helper";

export let UserIndexView = Backbone.View.extend({
  id: "user-index-view",
  className: "top-margin",
  template: _.template($("#user-index-view-template").html()),
  events: {
    "click #two-factor-toggle": "changeTwoFactorAuth",
    "click #avatar-change-button": "showImageUploadModal",
    "click #guild-invite-button": "inviteGuild",
  },

  inviteGuild: function () {
    console.log("not working");
  },

  changeTwoFactorAuth: function () {
    const after_value = $("#two-factor-toggle input").is(":checked");
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

  showImageUploadModal: function () {
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

  inviteGuild: function () {},

  initialize: function (id) {
    this.user_id = id;
    let invite_possible =
      id != App.current_user.id &&
      App.current_user.get("guild") != null &&
      App.current_user.get("guild").position != "member";

    this.$el.html(
      this.template({
        is_current_user: id == App.current_user.id,
        invite_possible: invite_possible,
      })
    );

    this.model = new App.Model.User({ id: id });
    this.user_profile_view = new App.View.UserProfileCardView();
    this.model.fetch({
      data: { for: "profile" },
      success: function (data) {
        this.user_profile_view.render(data.toJSON());
      }.bind(this),
    });
  },

  render: function () {
    this.$(".user-profile-view").append(this.user_profile_view.$el);

    this.guild_invitation_list = new App.View.guildInvitationListView();
    this.guild_invitation_list
      .setElement(this.$("#guild-invitation-list-view"))
      .render(data);

    // this.match_history_list = new App.View.matchHistoryListView();
    // this.match_history_list
    //   .setElement(this.$(".match-history-list-view"))
    //   .render(data);

    return this;
  },

  close: function () {
    // listenTo는 view 삭제시 삭제되므로 누수 방지를 위해 on으로 설정한 event만 off 처리
    this.remove();
  },
});
