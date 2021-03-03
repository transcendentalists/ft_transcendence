import { App } from "srcs/internal";

export let AdminIndexView = Backbone.View.extend({
  id: "admin-index-view",
  className: "flex-container column-direction center-aligned top-margin",
  template: _.template($("#admin-index-view-template").html()),
  events: {
    "click .menu a": "changeResource",
    "click .admin-action.button": "adminAction",
  },

  // ban, user
  // ban-release, user

  // destroy, chat-channel
  // show, chat-channel

  // give, chat-channel, membership, position
  // remove, chat-channel, membership, position

  // give, guild, membership, position
  // remove, guild, membership, position

  // create, tournament

  url: function () {
    let url = this.resource;
    if (["users", "group_chat_rooms"].includes(this.resource))
      return url + "/" + this.child_views[1].getResourceId();
    return url + "/" + this.child_views[2].getResourceId();
  },

  requestMethod: function () {
    return this.child_views[0].getMethod();
  },

  initialize: function () {
    this.$el.html(this.template());
    this.resource = "users";
    this.child_views = [];
    this.db = null;
  },

  adminAction: function () {
    Helper.fetch(this.url(), {
      method: this.requestMethod(),
      body: {},
      success_callback: () => {
        Helper.info({
          subject: "요청 성공",
          description: "요청하신 액션이 성공적으로 수행되었습니다.",
        });
      },
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    });
  },

  changeHeader: function (event) {
    $(".menu a.header").removeClass("header");
    event.target.classList.add("header");
  },

  optionsRender: function (new_resource) {
    this.child_views.forEach((child_view) =>
      child_view.render({ resource: new_resource })
    );
  },

  changeResource: function (event) {
    const new_resource = event.target.getAttribute("data-resource-name");
    if (this.resource == new_resource) return;
    if (new_resource == "tournament")
      return App.router.navigate("#/tournaments/new");
    this.changeHeader(event);
    this.resource = new_resource;
    this.optionsRender(this.resource);
  },

  setDatabase: function (data) {
    this.db = data.db;
    this.optionsRender(this.resource);
  },

  render: function () {
    ["action", "resource", "user", "position"].forEach((type) =>
      this.child_views.push(
        new App.View.AdminOptionView({ parent: this, type: type })
      )
    );

    Helper.fetch("admin/db", {
      success_callback: this.setDatabase.bind(this),
    });

    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.remove();
  },
});
