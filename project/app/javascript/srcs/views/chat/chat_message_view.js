import { Helper } from "srcs/internal";

export let ChatMessageView = Backbone.View.extend({
  tagName: "div",
  className: "comment",

  initialize: function (option) {
    this.model = option.model;
    this.template = option.template;
    this.chat_user = option.chat_user;
  },

  render: function () {
    this.$el.html(
      this.template({
        name: this.chat_user.name,
        image_url: this.chat_user.image_url,
        created_at: Helper.getMessageTime(this.model.get("created_at")),
        message: this.model.get("message"),
      })
    );
    return this;
  },

  close: function () {
    this.remove();
  },
});
