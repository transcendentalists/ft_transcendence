import { App, Helper } from "../../internal";

export let WarRequestCardView = Backbone.View.extend({
  template: _.template($("#war-request-card-view-template").html()),
  className:
    "ui segment profile-card war-request-card flex-container center-aligned",

  events: {
    "click #war-request-accept-button": "acceptWarRequest",
    "click #war-request-decline-button": "declineWarRequest",
  },

  initialize: function (data) {
    this.war_request_id = data.war_request_id;
    this.enemy_guild_id = data.enemy_guild_id;
  },

  acceptWarRequest: function () {
    const accept_war_request_url =
      "guilds/" + this.enemy_guild_id + "/war_requests/" + this.war_request_id;
    Helper.fetch(accept_war_request_url, {
      method: "PATCH",
      success_callback: function () {
        App.router.navigate("#/matches");
      },
      fail_callback: function () {
        Helper.info({
          subject: "수락 실패",
          description: "오류",
        });
      },
    });
  },

  declineWarRequest: function () {
    const decline_war_request_url =
      "guilds/" + this.enemy_guild_id + "/war_requests/" + this.war_request_id;
    Helper.fetch(decline_war_request_url, {
      method: "DELETE",
      success_callback: function () {
        App.router.navigate("#/guilds");
      },
      fail_callback: function () {
        Helper.info({
          subject: "거절 실패",
          description: "오류",
        });
      },
    });
  },

  render: function (data) {
    data.position = App.current_user.get("guild").position;
    this.$el.html(this.template(data));
    return this;
  },

  close: function () {
    this.$el.empty();
    this.remove();
  },
});
