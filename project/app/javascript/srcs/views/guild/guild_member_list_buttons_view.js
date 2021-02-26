import { App, Helper } from "srcs/internal";

export let GuildMemberListButtonsView = Backbone.View.extend({
  template: _.template($("#guild-member-list-buttons-view-template").html()),

  events: {
    "click .officer-assign-button": "assignOfficer",
    "click .member-ban-button": "banMember",
    "click .officer-dismiss-button": "dismissOfficer",
  },

  initialize: function (options) {
    this.parent = options.parent;
    this.guild_id = null;
    this.membership_id = null;
    this.current_user_guild_position = null;
    this.member_guild_position = null;
    this.member_ban_button = false;
    this.officer_assign_button = false;
    this.officer_dismiss_button = false;
  },

  assignOfficer: function () {
    const assign_officer_url = `guilds/${this.guild_id}/memberships/${this.membership_id}`;
    Helper.fetch(assign_officer_url, {
      method: "PATCH",
      body: {
        position: "officer",
      },
      success_callback: (data) => {
        this.parent.refresh(data.guild_membership);
      },
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    });
  },

  dismissOfficer: function () {
    const dismiss_officer_url = `guilds/${this.guild_id}/memberships/${this.membership_id}`;
    Helper.fetch(dismiss_officer_url, {
      method: "PATCH",
      body: {
        position: "member",
      },
      success_callback: (data) => {
        this.parent.refresh(data.guild_membership);
      },
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    });
  },

  banMember: function () {
    const ban_member_url = `guilds/${this.guild_id}/memberships/${this.membership_id}`;
    Helper.fetch(ban_member_url, {
      method: "DELETE",
      success_callback: () => {
        this.parent.close();
      },
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    });
  },

  setOfficerAssignButton: function () {
    if (this.isMember(this.member_guild_position)) this.officer_assign_button = true;
  },

  setOfficerDismissButton: function () {
    if ( this.isOfficer(this.member_guild_position) ) this.officer_dismiss_button = true;
  },

  setMemberBanButton: function () {
    this.member_ban_button = true;
  },

  setButtons: function (member) {
    this.current_user_guild_position = App.current_user.get("guild")?.position;
    this.member_guild_position = member.guild.position;

    if (this.isMember(this.current_user_guild_position)) return ;
    if (!this.isOfficer(this.current_user_guild_position)) {
      this.setOfficerAssignButton();
      this.setOfficerDismissButton();
    }
    if (!this.isMaster(this.member_guild_position)) this.setMemberBanButton();
  },

  render: function (member) {
    this.guild_id = member.guild.id;
    this.membership_id = member.guild.membership_id;
    this.setButtons(member);
    this.$el.html(
      this.template({
        officer_assign_button: this.officer_assign_button,
        officer_dismiss_button: this.officer_dismiss_button,
        member_ban_button: this.member_ban_button,
      })
    );
    return this;
  },

  isMaster: function (position) {
    return position == "master";
  },

  isOfficer: function (position) {
    return position == "officer";
  },

  isMember: function (position) {
    return position == "member";
  },

  close: function () {
    this.parent = null;
    this.remove();
  },
});
