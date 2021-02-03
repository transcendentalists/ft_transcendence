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
      data: $.param({ status: ["online", "playing"] }),
      reset: true,
    });
    window.aaa = this.online_users;
    return this;
  },

  close: function () {
    this.deleteAll();
    this.$el.remove();
  },

  addOne: function (user) {
    if (App.me.get("id") === user.get("id")) {
      return;
    }
    this.online_user_unit = new App.View.UserUnitView({ model: user });
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

  updateUserStatus: function (user_data) {
    let user = this.online_users.where({ id: user_data.id });

    // 컬렉션에 user 넣으면 알아서 model의 url에 id 를 따라서 세팅해준다
    if (user.length == 0) {
      user = new App.Model.User(user_data);
      this.online_users.add(user);
    } else if (user_data.status == "offline") {
      this.online_users.remove(user);
    }
  },
});
