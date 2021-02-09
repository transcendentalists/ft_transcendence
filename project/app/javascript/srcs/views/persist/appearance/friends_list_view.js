import { Users } from "../../../collections/users";
import { App } from "../../../internal";

export let FriendsListView = Backbone.View.extend({
  template: _.template($("#appearance-friends-list-view").html()),

  initialize: function (options) {
    this.parent = options.parent;
    this.chat_bans = this.parent.chat_bans;
    this.friends = this.parent.friends;

    this.listenTo(this.friends, "add", this.addOne);
    // this.listenTo(this.friends, "change: status", deleteOne);
    this.listenTo(this.friends, "reset", this.addAll);
    // this.listenTo(this.friends, "remove", this.deleteOne);
  },

  render: function () {
    this.$el.html(this.template());
    this.friends.fetch({
      // api/users/:id/friendships
      data: $.param({ for: "appearance" }),
      reset: true,
    });
    window.friends = this.friends;
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

  // deleteAll: function () {
  //   _.map(this.friends, function (user) {
  //     user.trigger("clear");
  //   });
  // },

  isUserInTheCollection: function (user_data) {
    if (this.friends.where({ id: user_data.id }).length != 0) {
      return true;
    } else {
      return false;
    }
  },

  updateUserStatus: function (user_data) {
    let user = this.friends.where({ id: user_data.id })[0];

    if (!user.length) return;
    if (user_data.status == "online") {
      user.set({ status: "online" });
    } else if (user_data.status == "offline") {
      user.set({ status: "offline" });
    } else {
      user.set({ status: "playing" });
    }
  },
});
