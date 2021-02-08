import { App, Helper } from "../../../internal";

export let UserMenuView = Backbone.View.extend({
  template: _.template($("#user-menu-view-template").html()),
  id: "user-menu-view",

  events: {
    mouseleave: "close",
    "click [data-event-name=direct-chat]": "directChat",
    "click [data-event-name=create-chat-ban]": "createChatBan",
    "click [data-event-name=destroy-chat-ban]": "destroyChatBan",
    "click [data-event-name=new-friend]": "newFriend",
    "click [data-event-name=battle]": "battle",
    "click [data-event-name=user-ban]": "userBan",
  },
  // chatbans collection
  // 1) current_user가 chatBan한 녀석들의 집합
  // url: api/users/:user_id/chat_bans

  // 0. iwoo2로 로그인했을 때, 기존에 iwoo2에 의해 chatBan 되었던 유저의 user_unit을 클릭하면, 유저 메뉴에 chatBan 버튼이 'chatBan 해제하기' 버튼으로 변경되어 나타난다.
  // 이건 아래 내용대로 하자.
  // --------로그인하면서 collection을 fetch해둔다. 끝.

  // 1. sanam1 user_unit을 클릭하여 나타난 유저메뉴의 chatBan 버튼을 클릭하면, chatBan DB record를 create하는 POST 요청을 서버에 날린다.
  // 2. 그리고 '어떤 방법'으로 iwoo2가 sanam1을 chatBan 했다는 사실을 user_menu_view가 감지한다.                                   <-- 어떤 방법? 어떤 시점?
  // 이건 아래 내용대로 하자.
  // --------1) Helper.fetch로 POST 요청을 날린다. ok
  // --------2) promise chain으로 rails에 처리가 성공했다는 응답을 받는다. -> success callback 지정해주자
  // --------3) 이어서 우리 collection을 fetch한다. -> chat_bans 를 fetch 해준다 -> reset 이벤트발동
  // 3. 이제 sanam1 user_unit을 클릭하면, 유저 메뉴에 chatBan 버튼이 'chatBan 해제하기' 버튼으로 변경되어 나타난다.
  // 4. 이 chatBan 해제하기 버튼을 클릭하면, chatBan DB record를 destroy하는 DELETE 요청을 서버에 날린다.

  // current_user.bans() <= 이런 식으로 하는 것은 결국 메서드로 구현하기로 했다.

  initialize: function (options) {
    this.parent = options.parent;
    this.online_users = options.parent.online_users;
    this.chat_bans = options.parent.chat_bans;
    this.listenTo(this.online_users, "destroy_user_menu_all", this.close);
    this.listenTo(window, "resize", this.close);
  },

  directChat: function () {
    // this.model
    App.appView.direct_chat_view.render();
    console.log("directChat!!");
    this.close();
  },

  chatBanSuccessCallback: function (data) {
    // new ChatBan 을 해서 그걸 add 하자.
    console.log("chat_bans fetch");
    this.chat_bans.fetch(); // add 이벤트 발동
  },

  createChatBanParams: function () {
    return {
      method: "POST",
      success_callback: this.chatBanSuccessCallback.bind(this),
      body: {
        banned_user: {
          id: this.model.get("id"),
        },
      },
    };
  },

  destroyChatBanParams: function () {
    return {
      method: "DELETE",
      success_callback: this.chatBanSuccessCallback.bind(this),
    };
  },

  createChatBan: function () {
    // this.chat_bans.createChatBan(this.model.get("id"));
    Helper.fetch(
      `users/${App.current_user.id}/chat_bans`,
      this.createChatBanParams()
    );
    this.close();
  },

  destroyChatBan: function () {
    // this.chat_bans.destroyChatBan(this.model.get("id"));
    Helper.fetch(
      `users/${App.current_user.id}/chat_bans/${this.model.id}`,
      this.destroyChatBanParams()
    );
    this.close();
  },

  newFriend: function () {
    // this.model
    console.log("newFriend!!");
    // this.close();
  },

  battle: function () {
    // this.model
    console.log("battle!!");
    // this.close();
  },

  userBan: function () {
    // this.model
    console.log("userBan!!");
    // this.close();
  },

  render: function (position) {
    this.$el.html(
      this.template({
        model: this.model,
        banned: this.chat_bans.isUserChatBanned(this.model.id),
      })
    );
    this.$el.css("position", "absolute");
    this.$el.css("top", position.top);
    this.$el.css("left", position.left - 127);
    this.$el.css("z-index", 103);
    return this;
  },

  close: function () {
    this.remove();
  },
});
