import { App, Helper } from "srcs/internal";

export let WarRequestCardView = Backbone.View.extend({
  template: _.template($("#war-request-card-view-template").html()),
  className:
    "ui segment profile-card war-request-card flex-container center-aligned",

  events: {
    "click #war-request-accept-button": "acceptWarRequest",
    "click #war-request-decline-button": "declineWarRequest",
  },

  initialize: function (war_request) {
    this.war_request_id = war_request.id;
    this.challenger_guild_id = war_request.challenger.id;
  },

  /**
   ** war 생성 API 가 없음
   */
  acceptWarRequest: function () {
    const accept_war_request_url = `guilds/${this.challenger_guild_id}/war`;
    Helper.fetch(accept_war_request_url, {
      method: "POST",
      success_callback: () => {
        App.router.navigate("#/war");
      },
      fail_callback: () => {},
    });
  },

  declineWarRequest: function () {
    const decline_war_request_url = `guilds/${this.challenger_guild_id}/war_requests/${this.war_request_id}`;
    Helper.fetch(decline_war_request_url, {
      method: "DELETE",
      success_callback: () => {
        App.current_user.fetch({
          data: { for: "profile" },
          success: () => {
            App.router.navigate("#/guilds", true);
          },
        });
      },
      fail_callback: data => {
        Helper.info({
          subject: data.error.type,
          description: data.error.msg,
        });
      },
    });
  },

  render: function (data) {
    data.current_user_position = App.current_user.get("guild")?.position;
    this.$el.html(this.template(data));
    return this;
  },

  close: function () {
    this.remove();
  },
});
