export let UserUnitView = Backbone.View.extend({
  tagName: "div",
  className: "item",
  template: _.template($("#appearance-user-list-unit-template").html()),

  initialize: function () {
    this.listenTo(this.model, "remove", this.close);
    this.listenTo(this.model, "change:status", this.changeStatus);
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

  changeStatus: function() {
    this.render();
  },

  close: function () {
    console.log(this.model.get("name") + " unit view is remove!!!!");
    this.$el.remove();
  },
});
