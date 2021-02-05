import { App, Helper } from "../../../internal";

export let UserMenuView = Backbone.View.extend({
  template: _.template($("#user-menu-view-template").html()),
  id: "user-menu-view",

  events: {
    mouseleave: "close",
    "click [data-event-name=direct-chat]": "directChat",
    "click [data-event-name=chat-ban]": "chatBan",
    "click [data-event-name=new-friend]": "newFriend",
    "click [data-event-name=battle]": "battle",
    "click [data-event-name=user-ban]": "userBan",
  },

  directChat: function () {
    // this.model
    App.appView.direct_chat_view.render();
    console.log("directChat!!");
  },

  chatBanParams: function () {
    return {
      method: "POST",
      body: {
        banned_user: {
          id: this.model.get("id"),
        },
      },
    };
  },

  chatBan: function () {
    console.log(`users/${App.current_user.id}/chat_bans`);
    Helper.fetch(
      `users/${App.current_user.id}/chat_bans`,
      this.chatBanParams(),
    );
    console.log("chatBan!!");
  },

  newFriend: function () {
    // this.model
    console.log("newFriend!!");
  },

  battle: function () {
    // this.model
    console.log("battle!!");
  },

  userBan: function () {
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
    this.remove();
  },
});
