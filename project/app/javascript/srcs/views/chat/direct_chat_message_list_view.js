import { App, Helper } from "srcs/internal";

export let DirectChatMessageListView = Backbone.View.extend({
  el: "#direct-chat-view .comments",
  general_user_message_template: _.template(
    $("#chat-message-view-template").html()
  ),
  current_user_message_template: _.template(
    $("#current-user-chat-message-view-template").html()
  ),

  initialize: function (options) {
    this.message_list = options.collection;
    this.room_id = options.room_id;
    this.current_user = App.current_user.attributes;
    this.chat_user = options.chat_user.attributes;
    this.child_views = [];
    this.channel = null;
  },

  scrollDown: function () {
    $("#direct-chat-view .comments").animate(
      {
        scrollTop: $("#direct-chat-view .comments").get(0).scrollHeight,
      },
      2000
    );
  },

  addOne: function (message) {
    if (Helper.isUserChatBanned(message.get("user_id"))) return;
    this.message_view = new App.View.ChatMessageView({
      model: message,
      chat_user:
        message.get("user_id") == this.chat_user.id
          ? this.chat_user
          : this.current_user,
      template:
        message.get("user_id") != App.current_user.id
          ? this.general_user_message_template
          : this.current_user_message_template,
    });
    this.child_views.push(this.message_view);
    this.$el.append(this.message_view.render().$el);
  },

  addAll: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.message_list.forEach((message) => this.addOne(message));
  },

  render: function () {
    this.listenTo(this.message_list, "add", this.addOne);
    this.listenTo(this.message_list, "reset", this.addAll);
    this.listenTo(this.message_list, "scroll", this.scrollDown);
    this.channel = App.Channel.ConnectDirectChatChannel(
      this.message_list,
      this.room_id
    );
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
    this.message_list.remove();
    this.remove();
  },
});
