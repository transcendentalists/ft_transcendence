import { App, Helper } from "srcs/internal";

export let MainButtonsView = Backbone.View.extend({
  el: "#main-buttons-view",
  template: _.template($("#main-buttons-view-template").html()),
  events: {
    "click .admin.button": "redirectAdminPage",
    "click .help.button": "showHelpInfoModal",
    "click .logout.button ": "logout",
  },

  redirectAdminPage: function () {
    App.router.navigate("#/admin");
  },

  showHelpModal: function () {
    Helper.info({
      subject: "도움말",
      description: `패들(라켓)을 위아래로 움직여 공을 주고받는 탁구 스타일의 1:1 아케이드 게임, Pong을 기반으로 하는 서비스입니다.
        랭킹에 영향을 주는 승급전, 영향을 주고 받지 않는 친선전과 듀얼, 토너먼트, 길드와 길드전(War) 등의 다양한 게임 모드를 지원합니다.
        일반적으로 3점을 먼저 내는 쪽이 승리하며, 승급전/친선전 이외의 모드에서는 기본 규칙 이외에도 6가지 확장 규칙을 즐길 수 있습니다.
        1:1 채팅이나 그룹 채팅도 이용할 수 있으니 멋진 아케이드 게임 서비스, 트렌센던스를 마음껏 누려보세요!
        `,
    });
  },

  logout: function () {
    App.restart();
  },

  render: function (options = { position: "user" }) {
    console.log("🚀 ~ file: main_buttons_view.js ~ line 33 ~ options", options);
    this.$el.html(this.template(options));
    return this;
  },

  close: function () {
    this.remove();
  },
});
