import { App, Helper } from "srcs/internal";

export let GameIndexView = Backbone.View.extend({
  template: _.template($("#game-index-view-template").html()),
  id: "game-index-view",

  initialize: function (id) {
    this.spec = null;
    this.channel = null;
    this.is_player = id == undefined ? true : false;
    this.match_id = id;
    this.left_player_view = null;
    this.right_player_view = null;
    this.play_view = null;
    this.clear_id = null;
  },

  joinGame: function () {
    Helper.fetch("matches", {
      method: "POST",
      success_callback: this.subscribeChannel.bind(this),
      body: {
        for: "ladder",
        user_id: App.current_user.id,
      },
    });
  },

  subscribeChannel: function (data) {
    this.channel = App.Channel.ConnectGameChannel(
      this.recv,
      this,
      this.is_player ? data["match"]["id"] : data
    );
  },

  sendInformation: function (type) {
    Helper.info({
      subject: "게임종료",
      description:
        (type == "END"
          ? "게임이 종료되었습니다. "
          : "유저가 게임을 기권하였습니다. ") +
        "잠시후 홈 화면으로 이동합니다.",
    });
  },

  redirectHomeCallback: function () {
    return App.router.navigate("#/");
  },

  recv: function (msg) {
    if (
      msg.type == "START" ||
      (msg.type == "ENTER" && App.current_user.id == msg["send_id"])
    ) {
      this.spec = msg;
      this.renderPlayerView(msg);
    } else if (msg.type == "BROADCAST") {
      if (this.play_view == null && !this.is_player) {
        this.play_view = new App.View.GamePlayView(this, this.spec);
        this.play_view.update(msg);
        this.start();
      } else this.play_view.update(msg);
    } else if (msg.type == "END" || msg.type == "ENEMY_GIVEUP") {
      if (this.play_view) this.play_view.stopRender();
      if (this.clear_id) clearInterval(this.clear_id);
      this.sendInformation(msg.type);
      setTimeout(this.redirectHomeCallback, 3000);
      this.channel.unsubscribe();
      this.channel = null;
    }
  },

  renderPlayerView: function (data) {
    this.left_player_view = new App.View.UserProfileCardView();
    this.right_player_view = new App.View.UserProfileCardView();
    this.$(".vs-icon").html("VS");
    this.$("#left-game-player-view").append(
      this.left_player_view.render(data["left"]).$el
    );
    this.$("#right-game-player-view").append(
      this.right_player_view.render(data["right"]).$el
    );

    // 게임 시작 전부터 들어와있던 플레이어와 게스트들은 카운트다운 후 시작,
    this.$(".ui.active.loader").removeClass("active loader");
    this.$("#count-down-box").empty();
    if (this.is_player) this.countDown();
  },

  countDown: function () {
    let $box = this.$("#count-down-box");
    $box.html(10);
    this.clear_id = setInterval(
      function () {
        $box.text(+$box.text() - 1);
        if ($box.text() == 0) {
          clearInterval(this.clear_id);
          this.clear_id = null;
          $box.empty();
          this.start();
        }
      }.bind(this),
      1000
    );
  },

  start: function () {
    if (this.is_player)
      this.play_view = new App.View.GamePlayView(this, this.spec);
    this.play_view.render();
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());
    if (this.is_player) this.joinGame();
    else this.subscribeChannel(this.match_id);
    return this;
  },

  close: function () {
    if (this.left_player_view) this.left_player_view.close();
    if (this.right_player_view) this.right_player_view.close();
    if (this.play_view) this.play_view.close();
    if (this.channel) this.channel.unsubscribe();
    this.remove();
  },
});
