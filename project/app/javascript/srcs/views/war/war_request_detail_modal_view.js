import { App, Helper } from "srcs/internal";

export let WarRequestDetailModalView = Backbone.View.extend({
  template: _.template($("#war-request-detail-modal-view-template").html()),
  id: "war-request-detail-modal-view",
  className: "ui tiny modal transition",

  events: {
    "click .war-request-accept-button": "acceptWarRequest",
    "click .war-request-decline-button": "declineWarRequest",
    "click .war-request-close-button": "close",
  },

  initialize: function (options) {
    this.parent = options.parent;
    this.war_request = this.parent.war_request;
  },

  acceptWarRequest: function () {
    const accept_war_request_url = `guilds/${
      App.current_user.get("guild").id
    }/war_requests/${this.war_request.id}`;
    Helper.fetch(accept_war_request_url, {
      method: "PATCH",
      body: { status: "accepted" },
      success_callback: () => {
        App.router.navigate("#/war");
        this.close();
      },
      fail_callback: (data) => {
        this.close();
        Helper.info({ error: data.error });
      },
    });
  },

  declineWarRequest: function () {
    const decline_war_request_url = `guilds/${
      App.current_user.get("guild").id
    }/war_requests/${this.war_request.id}`;
    Helper.fetch(decline_war_request_url, {
      method: "PATCH",
      body: { status: "canceled" },
      success_callback: () => {
        this.parent.close();
      },
      fail_callback: (data) => {
        this.close();
        Helper.info({ error: data.error });
      },
    });
  },

  render: function () {
    this.war_request["current_user_position"] = App.current_user.get(
      "guild"
    ).position;
    this.$el.html(this.template(this.war_request));
    return this;
  },

  close: function () {
    $("#war-request-detail-modal-view").modal("hide");
    this.parent.war_request_detail_modal_view = null;
    this.remove();
  },
});
