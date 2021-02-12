import { App } from "srcs/internal";
import { Helper } from "../../helper";

export let ChatMessageListView = Backbone.View.extend({
  el: "#direct-chat-view .comments",
  general_user_message_template: _.template($("#chat-message-template").html()),
  current_user_message_template: _.template(
    $("#current-user-chat-message-view-template").html()
  ),

  initialize: function (options) {
    this.message_list = options.collection;
    this.room_id = options.room_id;
    this.chat_user = options.chat_user;
    this.child_views = [];
    this.channel = null;
  },

  scrollDown: function () {
    $("#direct-chat-view").animate(
      {
        scrollTop: $("#direct-chat-view").get(0).scrollHeight,
      },
      2000
    );
  },

  addOne: function (message) {
    if (Helper.isUserChatBanned(message.user_id)) return;
    if (message.user_id)
      this.message_view = new App.View.ChatMessageView({
        model: message,
        template:
          message.user_id != App.current_user.id
            ? this.general_user_message_template
            : this.current_user_message_template,
      });
    this.child_views.push(this.message_view);
    this.$el.append(this.message_view.render().$el);
    this.scrollDown();
  },

  addAll: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.message_list.forEach((message) => this.addOne(message));
  },

  render: function () {
    this.listenTo(this.message_list, "add", this.addOne);
    this.listenTo(this.message_list, "reset", this.addAll);
    this.channel = App.Channel.ConnectDirectChatChannel(
      this.addOne,
      this,
      this.room_id
    );
  },

  stop: function () {
    this.stopListening();
    this.channel.unsubscribe();
    this.channel = null;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
