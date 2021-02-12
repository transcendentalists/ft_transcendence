export let ChatMessageView = Backbone.View.extend({
  className: "comment",

  initialize: function () {},

  render: function () {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

  close: function () {
    this.remove();
  },
});
