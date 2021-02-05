import { Helper } from "../../../helper";
import { App } from "../../../internal";

export let UserUnitView = Backbone.View.extend({
  tagName: "div",
  className: "item",
  template: _.template($("#appearance-user-list-unit-template").html()),

  events: {
    "click ": "showUserMenu",
  },

  initialize: function () {
    this.listenTo(this.model, "remove", this.close);
    this.listenTo(this.model, "change:status", this.changeStatus);
  },

  showUserMenu: function() {
    console.log(this.model.get("name") + " is clicked!");

    let position = this.$el.offset();
    this.user_menu_view = new App.View.UserMenuView({ model: this.model });
    $("#root").append(this.user_menu_view.render(position).$el);
  },

  render: function () {
    window.unit = this.$el
    this.$el.html(
      this.template({
        name: this.model.get("name"),
        status: this.model.get("status"),
      })
    );
    return this;
  },

  changeStatus: function() {
    if (this.model.get("status") == "playing") {
      this.$el.find('.circular').removeClass("green");
      this.$el.find('.circular').addClass("yellow");
    } else if (this.model.get("status") == "online") {
      this.$el.find('.circular').removeClass("yellow");
      this.$el.find('.circular').addClass("green");
    }
  },

  close: function () {
    console.log(this.model.get("name") + " unit view is remove!!!!");
    this.$el.remove();
  },
});
