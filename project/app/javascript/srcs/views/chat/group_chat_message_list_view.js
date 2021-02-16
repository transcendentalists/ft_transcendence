import { App } from "srcs/internal";
import { Helper } from "../../helper";

export let GroupChatMessageListView = Backbone.View.extend({
  el: "#chat-room-message-list-view",
  message_template: _.template($("#chat-message-view-template").html()),

  initialize: function (options) {
    this.parent = options.parent;
    this.messages = this.parent.chat_messages;
    this.chat_room_members = this.parent.chat_room_members;
    this.room_id = this.parent.room_id;
    this.child_views = [];
    this.channel = null;

    this.listenTo(this.messages, "add", this.addOne);
    this.listenTo(this.messages, "reset", this.addAll);
    this.listenTo(this.messages, "scroll", this.scrollDown);
  },

  scrollDown: function () {
    $("#chat-room-view .comments").animate(
      {
        scrollTop: $("#chat-room-view .comments").get(0).scrollHeight,
      },
      2000
    );
  },

  addOne: function (message) {
    if (Helper.isUserChatBanned(message.get("user_id"))) return;
    const chat_user = this.chat_room_members.get(message.get("user_id"));
    this.message_view = new App.View.ChatMessageView({
      model: message,
      chat_user: chat_user.attributes,
      template: this.message_template,
    });
    if (chat_user.id == App.current_user.id)
      this.message_view.$el.addClass("current-user");
    this.child_views.push(this.message_view);
    this.$el.append(this.message_view.render().$el);
  },

  addAll: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.messages.forEach((message) => this.addOne(message));
  },

  render: function () {
    // this.channel = App.Channel.ConnectDirectChatChannel(
    //   this.messages,
    //   this,
    //   this.room_id
    // );
    return this;
  },

  stop: function () {
    this.stopListening();
    if (this.channel) this.channel.unsubscribe();
    this.channel = null;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.messages.remove();
    this.remove();
  },
});
