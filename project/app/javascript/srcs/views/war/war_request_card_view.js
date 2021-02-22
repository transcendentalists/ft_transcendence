import { App, Helper } from "srcs/internal";

export let WarRequestCardView = Backbone.View.extend({
  template: _.template($("#war-request-card-view-template").html()),
  className:
    "ui segment profile-card war-request-card flex-container center-aligned",

  events: {
    "click .war-request-detail-button": "showWarRequestDetail",
  },

  initialize: function (war_request) {
    this.war_request = war_request;
    this.war_request_detail_modal_view = null;
  },

  showWarRequestDetail: function () {
    this.war_request_detail_modal_view = new App.View.WarRequestDetailModalView({ parent: this });
    this.war_request_detail_modal_view.render();
  },

  render: function () {
    this.$el.html(
      this.template({
        war_request: this.war_request,
        current_user_position: App.current_user.get("guild")?.position,
      }),
    );
    return this;
  },

  close: function () {
    if (this.war_request_detail_modal_view) {
      this.war_request_detail_modal_view.close();
    }
    this.remove();
  },
});
