import { App } from "srcs/internal";
import { Helper } from "../../helper";

export let UserIndexView = Backbone.View.extend({
  id: "user-index-view",
  className: "top-margin",
  template: _.template($("#user-index-view-template").html()),

  initialize: function (user_id) {
    this.user_id = user_id;
    this.model = new App.Model.User({ id: this.user_id });
    this.user_profile_view = new App.View.UserProfileCardView();
    this.model.fetch({
      data: { for: "profile" },
      success: function (data) {
        this.user_profile_view.render(data.toJSON());
      }.bind(this),
    });

    this.user_index_buttons_view = null;
    this.guild_invitations_view = null;
    this.match_history_view = null;
  },

  renderUserIndexButtons: function () {
    this.buttons_view = new App.View.UserIndexButtonsView(this.user_id);
    this.buttons_view.setElement(this.$("#user-index-buttons-view")).render();
  },

  renderUserProfile: function () {
    this.$(".user-profile-view").append(this.user_profile_view.$el);
  },

  renderGuildInvitations: function () {
    this.guild_invitations_view = new App.View.GuildInvitationListView();

    const guild_invitations_url =
      "users/" + App.current_user.id + "/guild_invitations";

    Helper.fetch(guild_invitations_url, {
      success_callback: function (guild_invitations) {
        this.guild_invitations_view
          .setElement(this.$("#guild-invitation-list-view"))
          .render(guild_invitations);
      }.bind(this),
    });
  },

  renderMatchHistory: function () {
    this.match_history_view = new App.View.MatchHistoryListView();

    const match_history_url = "users/" + App.current_user.id + "/matches";

    Helper.fetch(match_history_url, {
      success_callback: function (match_history_list) {
        this.match_history_view
          .setElement(this.$(".match-history-list-view"))
          .render(match_history_list);
      }.bind(this),
    });
  },

  render: function () {
    this.$el.html(this.template());

    this.renderUserIndexButtons();
    this.renderUserProfile();
    this.renderGuildInvitations();
    this.renderMatchHistory();

    return this;
  },

  close: function () {
    if (this.user_index_buttons_view) this.user_index_buttons_view.close();
    if (this.user_profile_view) this.user_profile_view.close();
    if (this.guild_invitations_view) this.guild_invitations_view.close();
    if (this.match_history_view) this.match_history_view.close();
    this.remove();
  },
});
