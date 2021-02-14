import { App, Helper } from "srcs/internal";

export let ChatRoomCreateView = Backbone.View.extend({
  id: "chat-room-create-view",
  className: "create-view",
  template: _.template($("#chat-room-create-view-template").html()),
  events: {
    "click .create.button": "submit",
    "click .cancel.button": "cancel",
  },

  redirectChatRoomCallback: function (data) {
    App.router.navigate(`#/chatrooms/${data.group_chat_room.id}`);
  },

  createRoomParams: function (input_data) {
    return {
      method: "POST",
      success_callback: this.redirectChatRoomCallback.bind(this),
      fail_callback: (data) => App.router.navigate("#/errors/105"),
      body: {
        group_chat_room: input_data,
      },
    };
  },

  submit: function () {
    let input_data = {};
    input_data["title"] = $("input[name=title]").val();
    input_data["owner_id"] = App.current_user.id;
    input_data["password"] = $("input[name=password]").val();
    input_data["room_type"] = $("input[name=room_type]").is(":checked")
      ? "private"
      : "public";
    input_data["max_member_count"] = +$(
      ".max-member-count option:selected"
    ).val();

    Helper.fetch("group_chat_rooms", this.createRoomParams(input_data));
  },

  cancel: function () {
    App.router.navigate("#/chatrooms");
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());
    this.$(".ui.negative.message").hide();
    return this;
  },

  close: function () {
    this.remove();
  },
});
