export let UserUnitView = Backbone.View.extend({
  tagName: "div",
  className: "item",
  template: _.template($("#appearance-user-list-unit-template").html()),

  initialize: function () {
    this.listenTo(this.model, "remove", this.close);
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

  close: function () {
    console.log("close called!!");
    this.$el.remove();
  },
});
