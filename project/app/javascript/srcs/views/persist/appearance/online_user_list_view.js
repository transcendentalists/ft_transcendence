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
      data: $.param({ status: "online" }),
      reset: true,
    });
    window.users = this.online_users;

    // this.$(".ui.middle.aligned.selection.list").append(
    // this.online_user_unit.render().$el);

    // api/users/ + query 로 보내면, 이걸 백에서 알맞게 처리해주는 헬퍼 함수를 만들자.
    // 특정 상태의 모델을 가져오기 위해서는 query 를 fetch의 인자로 넣어서 가져오자
    return this;
  },

  close: function () {
    this.me_profile_card.remove();
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
  deleteAll: function () {},
});
