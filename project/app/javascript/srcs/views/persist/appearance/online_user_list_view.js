import { App } from "../../../internal";

export let OnlineUserListView = Backbone.View.extend({
  template: _.template($("#appearance-online-user-list-view").html()),

  initialize: function () {
    this.online_users = new App.Collection.Users();
  },

  render: function () {
    this.$el.html(this.template());
    this.online_users.fetch({ data: $.param({ status: "online" }) });
    window.users = this.online_users;
    // this.online_user_unit = new App.View.UserUnitView();

    // 1. users 컬렉션 fetch -> model, collection 생성하기
    // 2. 반복문을 돌리면서 조건에 따라 append
    // id, name, status
    // 뷰를 분리하는게 좋지 않을까?
    //  - friend view, user online view

    // api/users/ + query 로 보내면, 이걸 백에서 알맞게 처리해주는 헬퍼 함수를 만들자.
    // 특정 상태의 모델을 가져오기 위해서는 query 를 fetch의 인자로 넣어서 가져오자
  },
  close: function () {
    this.me_profile_card.remove();
  },
});
