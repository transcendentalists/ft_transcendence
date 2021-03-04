import { App } from "srcs/internal";

export let AdminIndexView = Backbone.View.extend({
  id: "admin-index-view",
  className: "flex-container column-direction center-aligned top-margin",
  template: _.template($("#admin-index-view-template").html()),
  events: {
    "click .menu a": "changeResource",
    "click .admin-action.button": "requestAdminAction",
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

  initialize: function () {
    this.$el.html(this.template());
    this.resource = "users";
    this.child_options = {
      action: null,
      resource: [],
      body: null,
    };
    this.db = null;
  },

  hasBodyAction() {
    return ["group_chat_memberships", "guild_memberships"].includes(
      this.resource
    );
  },

  url: function () {
    let url = this.resource;
    if (this.hasBodyAction())
      return url + "/" + this.child_options.resource.getResourceId();
    return url + "/" + this.child_options.membership.getResourceId();
  },

  requestMethod: function () {
    return this.child_options.method.getMethod();
  },

  showInfoModal: function () {
    return () => {
      Helper.info({
        subject: "요청 성공",
        description: "요청하신 액션이 성공적으로 수행되었습니다.",
      });
    };
  },

  showTableModal: function () {
    return (data) => {
      Helper.table(data);
    };
  },

  adminActionParams: function () {
    let params = {
      method: this.requestMethod(),
      success_callback:
        this.requestMethod() == "GET"
          ? this.showInfoModal()
          : this.showTableModal(),
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    };

    if (this.hasBodyAction()) {
      params.body = this.child_options.body.getBody();
    }

    return params;
  },

  requestAdminAction: function () {
    Helper.fetch(this.url(), adminActionParams());
  },

  changeHeader: function (event) {
    $(".menu a.header").removeClass("header");
    event.target.classList.add("header");
  },

  optionsRender: function (new_resource) {
    for (let key of Object.keys(this.child_options)) {
      this.child_options[key].render({ resource: new_resource });
    }
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

  setDatabase: function () {
    Helper.fetch("admin/db", {
      success_callback: (data) => {
        this.db = data.db;
        this.optionsRender(this.resource);
      },
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    });
  },

  render: function () {
    const option_keys = ["action", "resource", "membership", "position"];
    option_keys.forEach(function (type) {
      let child_option = new App.View.AdminOptionsView({
        parent: this,
        type: type,
      });
      this.child_options[type] = child_option;
    });
    this.setDatabase();
    return this;
  },

  close: function () {
    for (let key of Object.keys(this.child_options)) {
      this.child_options[key].close();
    }
    this.remove();
  },
});
