import { App } from "srcs/internal";

export let OnlineUserListView = Backbone.View.extend({
  template: _.template($("#appearance-online-user-list-view").html()),

  initialize: function (options) {
    this.parent = options.parent;
    this.chat_bans = this.parent.chat_bans;
    this.online_users = this.parent.online_users;
    this.friends = this.parent.friends;

    this.child_views = [];

    this.listenTo(this.online_users, "add", this.addOne);
    this.listenTo(this.online_users, "reset", this.addAll);
    // this.listenTo(this.online_users, "remove", this.deleteOne);
  },

  render: function () {
    this.$el.html(this.template());
    this.online_users.fetch({
      data: $.param({
        user_id: App.current_user.id,
        status: ["online", "playing"],
        for: "appearance",
      }),
      reset: true,
    });
    return this;
  },

  close: function () {
    for (child_view of this.child_views) {
      child_view.close();
    }
    this.$el.remove();
  },

  addOne: function (user) {
    if (App.current_user.get("id") === user.get("id")) {
      return;
    }
    this.online_user_unit = new App.View.UserUnitView({
      parent: this,
      model: user,
    });
    this.child_views.push(this.online_user_unit);
    this.$(".ui.middle.aligned.selection.list").append(
      this.online_user_unit.render().$el
    );
  },

  addAll: function () {
    for (let online_user of this.online_users) {
      this.addOne(online_user);
    }
  },

  // deleteOne: function (user) {
  //   console.log("deleteOne");
  //   console.log(this.online_users);
  //   user.clear();
  //   console.log(this.online_users);
  // },

  isUserInTheCollection: function (user_data) {
    if (this.online_users.where({ id: user_data.id }).length != 0) {
      return true;
    } else {
      return false;
    }
  },

  updateUserList: function (user_data) {
    if (user_data.status == "online") {
      if (this.isUserInTheCollection(user_data)) {
        let user = this.online_users.where({ id: user_data.id })[0];
        user.set({ status: "online" });
      } else {
        this.online_users.add(new App.Model.User(user_data));
      }
    } else if (user_data.status == "offline") {
      this.online_users.remove({ id: user_data.id });
    } else {
      let user = this.online_users.where({ id: user_data.id })[0];
      user.set({ status: "playing" });
    }
  },
});
