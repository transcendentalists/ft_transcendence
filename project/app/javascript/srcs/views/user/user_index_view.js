import { App, Helper } from "srcs/internal";

export let UserIndexView = Backbone.View.extend({
  id: "user-index-view",
  className: "top-margin",
  template: _.template($("#user-index-view-template").html()),

  initialize: function (user_id) {
    Helper.authenticateREST(user_id);
    this.user_id = user_id;
    this.model = new App.Model.User({ id: this.user_id });
    this.user_index_buttons_view = null;
    this.user_profile_view = null;
    this.guild_invitations_view = null;
    this.match_history_view = null;
  },

  render: function () {
    this.$el.html(
      this.template({ is_current_user: Helper.isCurrentUser(this.user_id) })
    );

    this.model.fetch({
      data: { for: "profile" },
      success: function (user) {
        this.renderUserProfile(user);
        this.renderUserIndexButtons();
      }.bind(this),
    });

    this.renderGuildInvitations();
    this.renderMatchHistory();

    return this;
  },

  renderUserProfile: function (user) {
    this.user_profile_view = new App.View.UserProfileCardView();
    this.$(".user-profile-view").append(
      this.user_profile_view.render(user.toJSON()).$el
    );
  },

  renderUserIndexButtons: function () {
    this.buttons_view = new App.View.UserIndexButtonsView(this.model);
    this.buttons_view.setElement(this.$("#user-index-buttons-view")).render();
  },

  renderGuildInvitations: function () {
    if (!Helper.isCurrentUser(this.user_id)) return;
    this.guild_invitations_view = new App.View.GuildInvitationListView();

    const guild_invitations_url =
      "users/" + App.current_user.id + "/guild_invitations";

    Helper.fetch(guild_invitations_url, {
      success_callback: (data) =>
        this.guild_invitations_view
          .setElement(this.$("#guild-invitation-list-view"))
          .render(data.guild_invitations),
    });
  },

  renderMatchHistory: function () {
    this.match_history_view = new App.View.MatchHistoryListView(this.user_id);

    const match_history_url = "users/" + this.user_id + "/matches";

    Helper.fetch(match_history_url, {
      success_callback: (match_history_list) =>
        this.match_history_view
          .setElement(this.$(".match-history-list-view"))
          .render(match_history_list),
    });
  },

  close: function () {
    if (this.buttons_view) this.buttons_view.close();
    if (this.user_profile_view) this.user_profile_view.close();
    if (this.guild_invitations_view) this.guild_invitations_view.close();
    if (this.match_history_view) this.match_history_view.close();
    this.remove();
  },
});
