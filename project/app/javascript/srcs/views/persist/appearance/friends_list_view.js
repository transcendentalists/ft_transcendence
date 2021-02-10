import { App } from "srcs/internal";

export let FriendsListView = Backbone.View.extend({
  template: _.template($("#appearance-friends-list-view").html()),

  initialize: function (options) {
    this.parent = options.parent;
    this.chat_bans = this.parent.chat_bans;
    this.friends = this.parent.friends;
    this.online_users = this.parent.online_users;

    this.child_views = [];

    this.listenTo(this.friends, "add", this.addOne);
    this.listenTo(this.friends, "reset", this.addAll);
  },

  render: function () {
    this.$el.html(this.template());
    this.friends.fetch({
      data: $.param({ for: "appearance" }),
      reset: true,
    });
    return this;
  },

  close: function () {
    for (let child_view of this.child_views) {
      child_view.close();
    }
    this.remove();
  },

  addOne: function (user) {
    if (App.current_user.get("id") === user.get("id")) {
      return;
    }
    this.friend_user_unit = new App.View.UserUnitView({
      parent: this,
      model: user,
      is_friend: true,
    });
    this.child_views.push(this.friend_user_unit);
    this.$("#appearance-friends-list").append(
      this.friend_user_unit.render().$el
    );
  },

  addAll: function () {
    for (let child_view of this.child_views) {
      child_view.close();
    }
    for (let online_user of this.friends) {
      this.addOne(online_user);
    }
  },

  updateUserList: function (user_data) {
    this.friends.get(user_data.id).set({ status: user_data.status });
  },
});
