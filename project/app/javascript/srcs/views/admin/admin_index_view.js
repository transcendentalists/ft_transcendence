import { App, Helper } from "srcs/internal";

export let AdminIndexView = Backbone.View.extend({
  id: "admin-index-view",
  className: "flex-container column-direction center-aligned top-margin",
  template: _.template($("#admin-index-view-template").html()),
  events: {
    "click .menu a": "changeResource",
    "click .admin-action.button": "requestAdminAction",
  },

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
    this.chat_modal_view = null;
  },

  hasBodyAction() {
    return this.child_selects.action.val() == "PATCH";
  },

  url: function () {
    let url = this.resource + "/";

    if (this.resource.endsWith("memberships"))
      url += this.child_selects.membership.val();
    else url += this.child_selects.resource.val();

    if (this.resource == "group_chat_rooms" && this.requestMethod() == "GET")
      url += "/chat_messages";

    return url;
  },

  requestMethod: function () {
    return this.child_selects.action.val();
  },

  showInfoModal: function () {
    Helper.info({
      subject: "요청 성공",
      description: "요청하신 액션이 성공적으로 수행되었습니다.",
    });
  },

  createChatMessagesTable(data) {
    return {
      title: `${data.title} (id: ${data.id})`,
      headers: ["user", "message", "at"],
      records: data.messages,
    };
  },

  showTableModal: function (data) {
    if (this.chat_modal_view == null)
      this.chat_modal_view = new App.View.TableModalView();
    this.chat_modal_view.render(
      this.createChatMessagesTable(data.chat_messages)
    );
  },

  adminActionCallback: function (data) {
    const method = this.requestMethod();
    if (method == "GET") return this.showTableModal(data);
    else if (method == "DELETE") {
      const resource = this.resource.endsWith("memberships")
        ? "membership"
        : "resource";
      this.db.destroy({
        resource: this.resource,
        resource_id: this.child_selects[resource].val(),
      });
      this.optionsRender(this.resource);
    }
    this.showInfoModal();
  },

  adminActionParams: function () {
    let params = {
      method: this.requestMethod(),
      headers: {
        admin: App.current_user.id,
      },
      success_callback: this.adminActionCallback.bind(this),
      fail_callback: (data) => {
        Helper.info({ error: data.error });
      },
    };

    if (this.hasBodyAction())
      params.body = { position: this.child_selects.position.val() };

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
        for (let key of Object.keys(this.child_selects))
          this.child_selects[key].setDB(this.db);
        this.optionsRender(this.resource);
      }.bind(this),
      fail_callback: () => {
        App.router.navigate("#/errors/400");
      },
    });
  },

  listenValueChange: function () {
    this.listenTo(this.child_selects.resource, "change", () =>
      this.child_selects.membership.render(this.resource)
    );
    this.listenTo(this.child_selects.action, "change", () =>
      this.child_selects.position.render(this.resource)
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
    this.listenValueChange();
    this.setDatabase();
    return this;
  },

  close: function () {
    for (let key of Object.keys(this.child_selects)) {
      this.child_selects[key].close();
    }
    if (this.chat_modal_view) this.chat_modal_view.close();
    this.remove();
  },
});
