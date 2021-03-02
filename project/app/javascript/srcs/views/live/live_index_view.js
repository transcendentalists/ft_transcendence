import { App, Helper } from "srcs/internal";

export let LiveIndexView = Backbone.View.extend({
  template: _.template($("#live-index-view-template").html()),
  id: "live-index-view",
  className: "flex-container column-direction center-aligned top-margin",
  events: {
    "click .menu a": "switchLiveType",
  },

  initialize: function (live_type) {
    this.live_type = live_type || "dual";
    this.live_card_list_view = null;
  },

  switchLiveType: function (event) {
    let live_type = event.target.getAttribute("data-live-type");
    App.router.navigate(`#/live/${live_type}`);
  },

  renderLiveCardList: function (data) {
    this.live_card_list_view = new App.View.LiveCardListView();
    this.live_card_list_view.render(data.matches);
  },

  redirectErrorPage: function (data) {
    App.router.navigate("#/errors/500");
  },

  render: function () {
    this.$el.html(this.template());
    this.$(`.${this.live_type}`).addClass("active");
    Helper.fetch(`matches?for=live&match_type=${this.live_type}`, {
      success_callback: this.renderLiveCardList.bind(this),
      fail_callback: this.redirectErrorPage.bind(this),
    });
    return this;
  },

  close: function () {
    if (this.live_card_list_view) this.live_card_list_view.close();
    this.remove();
  },
});
