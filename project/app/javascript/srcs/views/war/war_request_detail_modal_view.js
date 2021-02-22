import { App, Helper } from "srcs/internal";

export let WarRequestDetailModalView = Backbone.View.extend({
  template: _.template($("#war-request-detail-modal-view-template").html()),
  el: "#war-request-detail-modal-view",

  events: {
    "click .war-request-accept-button": "acceptWarRequest",
    "click .war-request-decline-button": "declineWarRequest",
    "click .right.floated.grey.icon": "hide",
  },

  initialize: function (options) {
    this.parent = options.parent;
    this.war_request = this.parent.war_request;
    $("#war-request-detail-modal-view").modal("setting", {
      closable: false,
    });
  },

  acceptWarRequest: function () {
    const accept_war_request_url = `guilds/${
      App.current_user.get("guild").id
    }/war_requests/${this.war_request.id}`;
    Helper.fetch(accept_war_request_url, {
      method: "PATCH",
      body: { status: "progress" },
      success_callback: () => {
        App.router.navigate("#/war");
      },
      fail_callback: (data) => {
        this.hide();
        Helper.info({
          subject: data.error.type,
          description: data.error.msg,
        });
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
        this.hide();
        Helper.info({
          subject: data.error.type,
          description: data.error.msg,
        });
      },
    });
  },

  hide: function () {
    $("#war-request-detail-modal-view").modal("hide");
    this.undelegateEvents();
    this.$el.empty();
  },

  render: function () {
    this.war_request["current_user_position"] = App.current_user.get(
      "guild"
    )?.position;
    this.$el.html(this.template(this.war_request));
    $("#war-request-detail-modal-view").modal("show");
    return this;
  },

  close: function () {
    $("#war-request-detail-modal-view").modal("hide");
    this.remove();
  },
});
