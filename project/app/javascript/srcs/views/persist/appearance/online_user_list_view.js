import { App } from "../../../internal";

export let OnlineUserListView = Backbone.View.extend({
  template: _.template($("#appearance-online-user-list-view").html()),

  initialize: function () {
    this.online_users = new App.Collection.Users();
    this.listenTo(this.online_users, "add", this.addOne);
    // listenTo(this.online_users, 'change: status', deleteOne);
    this.listenTo(this.online_users, "reset", this.addAll);
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

  deleteOne: function () {},

  deleteAll: function () {
    _.map(this.online_users, function (user) {
      user.trigger("clear");
    });
  },
});
