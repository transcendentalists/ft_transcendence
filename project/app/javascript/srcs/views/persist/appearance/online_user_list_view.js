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
    for (let child_view of this.child_views) {
      child_view.close();
    }
    this.remove();
  },

  addOne: function (user) {
    if (App.current_user.get("id") === user.get("id")) {
      return;
    }
    this.online_user_unit = new App.View.UserUnitView({
      parent: this,
      model: user,
      is_friend: false,
    });
    this.child_views.push(this.online_user_unit);
    this.$("#appearance-online-user-list").append(
      this.online_user_unit.render().$el
    );
  },

  addAll: function () {
    for (let online_user of this.online_users) {
      this.addOne(online_user);
    }
  },

  updateUserList: function (user_data) {
    let user = this.online_users.get(user_data.id);
    let status = user_data.status;

    if (status == "offline") {
      this.online_users.remove(user);
    } else if (status == "online" && user === undefined)
      this.online_users.add(new App.Model.User(user_data));
    else user.set({ status: user_data.status });
  },
});
