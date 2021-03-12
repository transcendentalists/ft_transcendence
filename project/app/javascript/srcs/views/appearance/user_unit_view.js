import { App } from "srcs/internal";

export let UserUnitView = Backbone.View.extend({
  tagName: "div",
  className: "item",
  template: _.template($("#appearance-user-list-unit-template").html()),

  events: {
    "click ": "destroyAndCreateUserMenu",
  },

  initialize: function (options) {
    this.parent = options.parent;
    this.online_users = options.parent.online_users;
    this.friends = options.parent.friends;
    this.chat_bans = options.parent.chat_bans;
    this.is_friend = options.is_friend;
    this.listenTo(this.model, "remove", this.close);
    this.listenTo(this.model, "change:status", this.changeStatus);
    this.listenTo(this.model, "create_user_menu", this.createUserMenu);
  },

  render: function () {
    this.$el.html(
      this.template({
        name: this.model.get("name"),
        status: this.model.get("status"),
      })
    );
    return this;
  },

  destroyAndCreateUserMenu: function () {
    App.app_view.appearance_view.trigger("destroy_user_menu_all");
    this.model.trigger("create_user_menu");
  },

  createUserMenu: function () {
    let position = this.$el.offset();

    this.user_menu_view = new App.View.UserMenuView({
      parent: this,
      model: this.model,
      is_friend: this.is_friend,
    });
    $("#root").append(this.user_menu_view.render(position).$el);
  },

  changeStatus: function () {
    this.$el.find(".circular").attr("data-status", this.model.get("status"));
  },

  close: function () {
    if (this.user_menu_view) this.user_menu_view.close();
    this.remove();
  },
});
