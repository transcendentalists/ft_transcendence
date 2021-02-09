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

  destroyAndCreateUserMenu: function () {
    this.online_users.trigger("destroy_user_menu_all");
    this.friends.trigger("destroy_user_menu_all");
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

  render: function () {
    this.$el.html(
      this.template({
        name: this.model.get("name"),
        status: this.model.get("status"),
      })
    );
    return this;
  },

  changeStatus: function () {
    if (this.model.get("status") == "playing") {
      this.$el.find(".circular").removeClass("gray");
      this.$el.find(".circular").removeClass("green");
      this.$el.find(".circular").addClass("yellow");
    } else if (this.model.get("status") == "online") {
      this.$el.find(".circular").removeClass("gray");
      this.$el.find(".circular").removeClass("yellow");
      this.$el.find(".circular").addClass("green");
    } else {
      this.$el.find(".circular").removeClass("yellow");
      this.$el.find(".circular").removeClass("green");
      this.$el.find(".circular").addClass("gray");
    }
  },

  close: function () {
    if (this.user_menu_view) this.user_menu_view.close();
    this.$el.remove();
  },
});
