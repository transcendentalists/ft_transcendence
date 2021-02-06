import { Users } from "../../../collections/users";
import { App } from "../../../internal";

export let OnlineUserListView = Backbone.View.extend({
  template: _.template($("#appearance-online-user-list-view").html()),

  initialize: function () {
    this.online_users = new App.Collection.Users();
    this.listenTo(this.online_users, "add", this.addOne);
    // this.listenTo(this.online_users, "change: status", deleteOne);
    this.listenTo(this.online_users, "reset", this.addAll);
    // this.listenTo(this.online_users, "remove", this.deleteOne);
  },

  render: function () {
    this.$el.html(this.template());
    this.online_users.fetch({
      data: $.param({ status: ["online", "playing"], for: "appearance" }),
      reset: true,
    });
    window.aaa = this.online_users;
    return this;
  },

  close: function () {
    // this.deleteAll();
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

  // deleteAll: function () {
  //   _.map(this.online_users, function (user) {
  //     user.trigger("clear");
  //   });
  // },

  isUserInTheCollection: function (user_data) {
    if (this.online_users.where({ id: user_data.id }).length != 0) {
      return true;
    } else {
      return false;
    }
  },

  updateUserStatus: function (user_data) {
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
