import { App, Helper } from "srcs/internal";
import consumer from "../../../../channels/consumer";

export let AppearanceView = Backbone.View.extend({
  el: "#appearance-view",
  template: _.template($("#appearance-view-template").html()),

  events: {
    "click .logout.button ": "logout",
  },

  initialize: function () {
    this.chat_bans = new App.Collection.ChatBans();
    this.online_users = new App.Collection.Users();
    this.friends = new App.Collection.Friends();
    window.friend = this.friends;
  },

  logout: function () {
    this.$el.empty();
    App.restart();
  },

  // 1. this.friends = new App.Collection.Users();
  // 2. this.friends.fetch( for: friend )
  // 이 때, current_user의 친구들만 fetch 받을 수 있도록 처리해야할 것.
  // 3. this.friend_list_view를 만들고, render시 friends collection과 연동시켜
  // 서 user_unit을 만들어서 표시해낸다.
  // 이 때 user_unit은 friends collection에 add 이벤트와 연동시켜서 생성할 것.
  // 4. 이후 online_users에서 friend에 있는 id는 제외해서 online_user list view를 만든다.
  // -----------------------------------------------------------------------------
  // 5. 만약 online_user_list_view의 user_unit을 클릭해서 나온 user_menu에서 친구추가를 누르면,
  // 6. online이_users에서 user을_unit의 id에 해당하는 model을 delete하고, friends에 해당
  // user_unit의 id에 해당하는 model을 add한다.

  render: function () {
    console.log("appearance view render~!!");
    this.chat_bans.fetch();

    this.appearance_channel = new App.Channel.ConnectAppearanceChannel();

    this.$el.empty();
    this.$el.html(this.template());

    this.friends_list_view = new App.View.FriendsListView({
      parent: this,
    });

    this.online_user_list_view = new App.View.OnlineUserListView({
      parent: this,
    });

    this.friends_list_view
      .setElement(this.$(".appearance.friends-list-view"))
      .render();

    this.online_user_list_view
      .setElement(this.$(".appearance.online-user-list-view"))
      .render();
  },

  close: function () {
    this.online_user_list_view.close();
    // this.remove();
  },

  updateUserStatus: function (user_data) {
    this.online_user_list_view.updateUserStatus(user_data);
  },
});
