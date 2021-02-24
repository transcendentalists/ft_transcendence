import { App, Helper } from "srcs/internal";

export let GuildMemberListButtonsView = Backbone.View.extend({
  template: _.template($("#guild-member-list-buttons-view-template").html()),

  events: {
    "click #officer-assign-button": "assignOfficer",
    "click #member-ban-button": "banMember",
    "click #officer-dismiss-button": "dismissOfficer",
  },

  initialize: function (option) {
    this.parent = option.parent;
    this.assign_button = false;
    this.ban_button = false;
    this.dismiss_button = false;
  },

  assignOfficer: function () {
    const assign_officer_url = `guilds/${this.guild_id}/memberships/${this.membership_id}`;
    Helper.fetch(assign_officer_url, {
      method: "PATCH",
      body: {
        position: "officer",
      },
      success_callback: (data) => {
        this.parent.refresh(data.guildMembership);
      },
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    });
  },

  // 관리자한테 길드탈퇴버튼 보임

  dismissOfficer: function () {
    const dismiss_officer_url = `guilds/${this.guild_id}/memberships/${this.membership_id}`;
    Helper.fetch(dismiss_officer_url, {
      method: "PATCH",
      body: {
        position: "member",
      },
      success_callback: (data) => {
        this.parent.refresh(data.guildMembership);
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
        Helper.info({ error: data.error })
      },
    });
  },

  render: function (data) {
    this.guild_id = data.guild.id;
    this.membership_id = data.guild.membership_id;

    if (data.guild_detail.current_user_guild_id == data.guild_detail.id) {
      if (data.id != App.current_user.id) {
        if (
          data.guild_detail.current_user_guild_position == "master" &&
          data.guild.position == "member"
        ) {
          this.assign_button = true;
        }
        if (
          data.guild_detail.current_user_guild_position == "master" &&
          data.guild.position == "officer"
        ) {
          this.dismiss_button = true;
        }
        if (data.guild_detail.current_user_guild_position != "member") {
          this.ban_button = true;
          if (
            (data.guild_detail.current_user_guild_position == "officer" &&
              data.guild.position == "master") ||
            (data.guild_detail.current_user_guild_position == "master" &&
              data.guild.position == "master")
          )
            this.ban_button = false;
        }
      }
    }

    this.$el.html(
      this.template({
        assign_button: this.assign_button,
        dismiss_button: this.dismiss_button,
        ban_button: this.ban_button,
      })
    );
    return this;
  },

  isMaster: function (data) {
    return (
      this.isMember(data) &&
      data.guild_detail.current_user_guild_position == "master"
    );
  },

  isOfficer: function (data) {
    return (
      this.isMember(data) &&
      data.guild_detail.current_user_guild_position == "officer"
    );
  },

  isMember: function (data) {
    return data.guild_detail.current_user_guild_id == data.guild_detail.id;
  },

  close: function () {
    this.parent = null;
    this.remove();
  },
});
