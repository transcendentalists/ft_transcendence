import { App, Helper } from "srcs/internal";

export let GuildMemberListButtonsView = Backbone.View.extend({
  template: _.template($("#guild-member-list-buttons-view-template").html()),

  events: {
    "click #officer-assign-button": "assignOfficer",
    "click #member-ban-button": "banMember",
    "click #officer-dismiss-button": "dismissOfficer",
  },

  initialize: function () {
    this.assign_button = false;
    this.ban_button = false;
    this.dismiss_button = false;
  },

  assignOfficer: function () {
    const assign_officer_url =
      "guilds/" + this.guild_id + "/memberships/" + this.membership_id;
    Helper.fetch(assign_officer_url, {
      method: "PATCH",
      body: {
        position: "officer",
      },
      success_callback: () => {
        App.router.navigate("#/guilds/" + this.guild_id + "/1", true);
      },
      fail_callback: (data) => {
        Helper.info({
          subject: data.error.type,
          description: data.error.msg,
        });
      },
    });
  },

  dismissOfficer: function () {
    const dismiss_officer_url =
      "guilds/" + this.guild_id + "/memberships/" + this.membership_id;
    Helper.fetch(dismiss_officer_url, {
      method: "PATCH",
      body: {
        position: "member",
      },
      success_callback: () => {
        App.router.navigate("#/guilds/" + this.guild_id + "/1", true);
      },
      fail_callback: (data) => {
        Helper.info({
          subject: data.error.type,
          description: data.error.msg,
        });
      },
    });
  },

  banMember: function () {
    const ban_member_url =
      "guilds/" + this.guild_id + "/memberships/" + this.membership_id;
    Helper.fetch(ban_member_url, {
      method: "DELETE",
      success_callback: () => {
        App.router.navigate("#/guilds/" + this.guild_id + "/1", true);
      },
      fail_callback: () => {
        Helper.info({
          subject: data.error.type,
          description: data.error.msg,
        });
      },
    });
  },

  render: function (data) {
    // data: guild_detail
    // console.log(data);
    this.guild_id = data.guild.id;
    this.membership_id = data.guild.membership_id;

    if (data.guild_detail.current_user_guild_id == data.guild_detail.id) {
      if (data.id != App.current_user.id) {
        if (
          data.guild_detail.current_user_guild_position == "owner" &&
          data.guild.position == "member"
        ) {
          this.assign_button = true;
        }
        if (
          data.guild_detail.current_user_guild_position == "owner" &&
          data.guild.position == "officer"
        ) {
          this.dismiss_button = true;
        }
        if (data.guild_detail.current_user_guild_position != "member") {
          this.ban_button = true;
          if (
            (data.guild_detail.current_user_guild_position == "officer" &&
              data.guild.position == "owner") ||
            (data.guild_detail.current_user_guild_position == "owner" &&
              data.guild.position == "owner")
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

  isOwner: function (data) {
    return (
      this.isMember(data) &&
      data.guild_detail.current_user_guild_position == "owner"
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
    this.remove();
  },
});
