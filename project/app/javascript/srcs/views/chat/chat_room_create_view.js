import { App, Helper } from "srcs/internal";

export let ChatRoomCreateView = Backbone.View.extend({
  id: "chat-room-create-view",
  className: "create-view top-margin",
  template: _.template($("#chat-room-create-view-template").html()),
  events: {
    "click .create.button": "submit",
    "click .cancel.button": "cancel",
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());
    return this;
  },

  submit: function () {
    let input_data = {};
    input_data.title = this.getInput("title");
    input_data.owner_id = App.current_user.id;
    input_data.password = this.getInput("password");
    input_data.room_type = this.getInput("room_type", { type: "check" });
    input_data.max_member_count = this.getInput("max-member-count", {
      type: "option",
    });

    Helper.fetch("group_chat_rooms", this.createRoomParams(input_data));
  },

  getInput: function (input_name, { type = "input" } = {}) {
    switch (type) {
      case "input":
        return document.forms[0][input_name].value;
      case "check":
        return $(`input[name=${input_name}]`).is(":checked")
          ? "private"
          : "public";
      case "option":
        return $(`.${input_name} option:selected`).val();
    }
  },

  createRoomParams: function (input_data) {
    return {
      method: "POST",
      success_callback: this.redirectChatRoomCallback.bind(this),
      fail_callback: () => App.router.navigate("#/errors/105"),
      body: {
        group_chat_room: input_data,
      },
    };
  },

  cancel: function () {
    App.router.navigate("#/chatrooms");
  },

  redirectChatRoomCallback: function (data) {
    App.router.navigate(`#/chatrooms/${data.group_chat_room.id}`);
  },

  close: function () {
    this.remove();
  },
});
