export let ChatIndexView = Backbone.View.extend({
  template: _.template($("#chat-index-view-template").html()),
  id: "chat-index-view",
  className: "flex-container column-direction center-aligned top-margin",

  initialize: function () {},

  render: function () {
    this.$el.html(this.template());
    this.my_chat_room_list_view.render();
    this.group_chat_room_list_view.render();
    return this;
  },

  close: function () {
    this.remove();
  },
});
