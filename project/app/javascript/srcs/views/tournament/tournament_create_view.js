import { App, Helper } from "srcs/internal";

export let TournamentCreateView = Backbone.View.extend({
  id: "tournament-create-view",
  className: "create-view top-margin",
  template: _.template($("#tournament-create-view-template").html()),
  events: {
    "click .create.button": "submit",
    "click .cancel.button": "cancel",
  },

  redirectChatRoomCallback: function (data) {
    App.router.navigate(`#/chatrooms/${data.group_chat_room.id}`);
  },

  getFormData: function () {
    const input_field = [
      "title",
      "incentive-gift",
      "incentive-title",
      "start-date",
    ];
    const select_field = [
      "max-user-count",
      "target-match-score",
      "rule-id",
      "tournament-time",
    ];

    let form_data = {};
    input_field.forEach(
      (column) =>
        (form_data[column.replaceAll("-", "_")] = this.$(
          `input[name=${column}]`
        ).val())
    );
    select_field.forEach(
      (column) =>
        (form_data[column.replaceAll("-", "_")] = this.$(
          `.${column} option:selected`
        ).val())
    );

    return form_data;
  },

  submit: function () {
    let form_data = this.getFormData();
    Helper.fetch("tournaments", {
      body: {
        tournament: form_data,
      },
      success_callback: () => App.router.navigate("#/tournaments"),
      fail_callback: (data) => Helper.info({ error: data.error }),
    });
  },

  cancel: function () {
    Backbone.history.history.back();
  },

  getMinDate: function () {
    const min = new Date();
    min.setDate(min.getDate() + 1);
    const month =
      min.getMonth() < 9 ? "0" + (min.getMonth() + 1) : min.getMonth() + 1 + "";
    const date = min.getDate() < 10 ? "0" + min.getDate() : min.getDate() + "";
    return min.getFullYear() + "-" + month + "-" + date;
  },

  render: function () {
    this.$el.html(
      this.template({
        min_date: this.getMinDate(),
      })
    );
    this.$(".ui.negative.message").hide();
    return this;
  },

  close: function () {
    this.remove();
  },
});
