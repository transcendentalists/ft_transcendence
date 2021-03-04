import { App, Helper } from "srcs/internal";

export let GuildMemberProfileCardView = Backbone.View.extend({
  template: _.template($("#guild-member-profile-card-template").html()),
  className: "ui segment profile-card flex-container center-aligned",

  initialize: function () {
    this.member = null;
    this.guild_member_profile_card_buttons_view = null;
  },

  refresh: function (guild) {
    this.member.guild = guild;
    this.guild_member_profile_card_buttons_view.close();
    this.render(this.member);
  },

  renderGuildMemberButtons: function () {
    this.guild_member_profile_card_buttons_view = new App.View.GuildMemberCardButtonsView(
      { parent: this }
    );
    this.guild_member_profile_card_buttons_view
      .setElement(this.$(".guild-member-card-buttons-view"))
      .render(this.member);
  },

  render: function (member) {
    this.member = member;
    this.$el.html(this.template(this.member));
    if (
      App.current_user.get("guild")?.id == this.member.guild.id &&
      !Helper.isCurrentUser(this.member.id)
    )
      this.renderGuildMemberButtons();
    return this;
  },

  close: function () {
    this.member = null;
    if (this.guild_member_profile_card_buttons_view)
      this.guild_member_profile_card_buttons_view.close();
    this.remove();
  },
});
