export let ChatRoomCreateView = Backbone.View.extend({
  // template: _.template($("#chat-room-create-view-template").html()),

  renderPasswordInputModal: function (room_id) {
    Helper.input({
      subject: "비밀번호 입력",
      description: "이 채팅방에 입장하려면 비밀번호 입력이 필요합니다.",
      success_callback: function (input) {
        app.router.navigate(`#/chatrooms/${room_id}/${input}`);
      },
    });
  },

  render: function () {},

  close: function () {
    this.remove();
  },
});
