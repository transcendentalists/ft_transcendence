import { App } from "../../../internal";

export let UserMenuView = Backbone.View.extend({
  template: _.template($("#user-menu-view-template").html()),

  events: {
    mouseleave: "close",
    "click [data-event-name=direct-chat]": "directChat",
    "click [data-event-name=chat-ban]": "chatBan",
    "click [data-event-name=new-friend]": "newFriend",
    "click [data-event-name=battle]": "battle",
    "click [data-event-name=user-ban]": "userBan",
  },

  directChat: function() {
    // this.model
    App.appView.direct_chat_view.render();
    console.log("directChat!!");
  },

  chatBan: function() {
    // this.model
    console.log("chatBan!!");
  },

  newFriend: function() {
    // this.model
    console.log("newFriend!!");
  },

  battle: function() {
    // this.model
    console.log("battle!!");
  },

  userBan: function() {
    // this.model
    console.log("userBan!!");
  },

  render: function (position) {
    this.$el.html(this.template(this.model));
    this.$el.css("position", "absolute");
    this.$el.css("top", position.top);
    this.$el.css("left", position.left - 127);
    this.$el.css("z-index", 103);
    return this;
  },

  clear: function () {
    this.template;
  },

  close: function () {
    this.$el.remove();
  },
});
