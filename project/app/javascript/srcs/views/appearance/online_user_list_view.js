import { App, Helper } from "srcs/internal";

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
    if (App.current_user.equalTo(user)) return;

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
    const user = this.online_users.get(user_data.id);
    let status = user_data.status;

    if (App.current_user.equalTo(user)) this.disconnectService();

    if (user === undefined) {
      if (status === "online")
        this.online_users.add(new App.Model.User(user_data));
      return;
    }

    user.set({ status: status });
    if (status === "offline") this.online_users.remove(user);
  },

  disconnectService: function () {
    Helper.info({
      subject: "중복 접속",
      description: "같은 계정의 트렌센던스 접속이 감지되었습니다.",
    });
    setTimeout(App.restart.bind(App), 2000);
  },
});
