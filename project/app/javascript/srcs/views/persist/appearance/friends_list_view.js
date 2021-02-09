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
    // this.listenTo(this.friends, "remove", this.deleteOne);
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
    this.$el.remove();
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
    this.$(".ui.middle.aligned.selection.list").append(
      this.friend_user_unit.render().$el
    );
  },

  addAll: function () {
    for (let child_view of this.child_views) {
      child_view.close();
    } // test 용도
    for (let online_user of this.friends) {
      this.addOne(online_user);
    }
  },

  // deleteOne: function (user) {
  //   console.log("deleteOne");
  //   console.log(this.friends);
  //   user.clear();
  //   console.log(this.friends);
  // },

  isUserInTheCollection: function (user_data) {
    if (this.friends.where({ id: user_data.id }).length != 0) {
      return true;
    } else {
      return false;
    }
  },

  updateUserList: function (user_data) {
    let user = this.friends.where({ id: user_data.id })[0];
    if (user_data.status == "online") {
      user.set({ status: "online" });
    } else if (user_data.status == "offline") {
      user.set({ status: "offline" });
    } else {
      user.set({ status: "playing" });
    }
  },
});
