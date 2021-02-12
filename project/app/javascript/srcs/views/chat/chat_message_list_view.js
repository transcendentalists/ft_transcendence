import { App } from "srcs/internal";

export let ChatMessageListView = Backbone.View.extend({
  el: "#direct-chat-view .comments",
  general_user_message_template: _.template(
    $("#appearance-friends-list-view").html()
  ),
  current_user_message_template: _.template(
    $("#appearance-friends-list-view").html()
  ),

  initialize: function (options) {
    this.message_list = options.collection;
    this.room_id = options.room_id;
    this.chat_user = options.chat_user;
    this.child_views = [];
    this.channel = null;
  },

  addOne: function (message) {
    if (message.user_id)
      this.message_view = new App.View.ChatMessageView({
        model: message,
        is_current_user: message.user_id == App.current_user.id,
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
