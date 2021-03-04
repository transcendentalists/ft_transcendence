import { App, Helper } from "srcs/internal";

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
    this.child_selects = {
      action: null,
      resource: null,
      membership: null,
      position: null,
    };
    this.db = null;
  },

  hasBodyAction() {
    return ["group_chat_memberships", "guild_memberships"].includes(
      this.resource
    );
  },

  url: function () {
    let url = this.resource + "/";
    if (this.hasBodyAction()) url += this.child_selects.membership.val();
    else url += this.child_selects.resource.val();

    url += this.hasBodyAction()
      ? this.child_selects.membership.val()
      : this.child_selects.resource.val();

    if (this.resource == "group_chat_rooms" && this.requestMethod() == "GET")
      url += "/chat_messages";

    return url;
  },

  requestMethod: function () {
    return this.child_selects.action.val();
  },

  showInfoModal: function () {
    return () => {
      Helper.info({
        subject: "요청 성공",
        description: "요청하신 액션이 성공적으로 수행되었습니다.",
      });
    };
  },

  createChatMessagesTable(data) {
    return null;
  },

  showTableModal: function () {
    return (data) => {
      console.log("success");
      // Helper.table(createChatMessagesTable(data));
    };
  },

  adminActionParams: function () {
    let params = {
      method: this.requestMethod(),
      headers: {
        admin: App.current_user.id,
      },
      success_callback:
        this.requestMethod() == "GET"
          ? this.showTableModal()
          : this.showInfoModal(),
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    };

    if (this.hasBodyAction()) {
      params.body = { position: this.child_selects.position.val() };
    }

    return params;
  },

  requestAdminAction: function () {
    Helper.fetch(this.url(), this.adminActionParams());
  },

  changeHeader: function (event) {
    $(".menu a.header").removeClass("header");
    event.target.classList.add("header");
  },

  optionsRender: function (new_resource) {
    for (let key of Object.keys(this.child_selects)) {
      this.child_selects[key].render(new_resource);
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
      success_callback: function (data) {
        this.db = new App.Model.AdminDB(data.db);
        this.optionsRender(this.resource);
        this.child_selects.membership.queryAndRenderOptions(
          this.child_selects.resource.select.val()
        );
      }.bind(this),
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    });
  },

  listenResourceChange: function () {
    this.listenTo(this.child_selects.resource, "change", (resource_id) =>
      this.child_selects.membership.queryAndRenderOptions(resource_id)
    );
  },

  render: function () {
    const select_keys = ["action", "resource", "membership", "position"];
    select_keys.forEach(function (type) {
      let child_select = new App.View.AdminSelectView({
        parent: this,
        type: type,
      });
      this.child_selects[type] = child_select;
    }, this);
    this.listenResourceChange();
    this.setDatabase();
    return this;
  },

  close: function () {
    for (let key of Object.keys(this.child_selects)) {
      this.child_selects[key].close();
    }
    this.remove();
  },
});
