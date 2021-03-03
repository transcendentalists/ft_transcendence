import { App, Helper } from "srcs/internal";

export let TournamentCreateView = Backbone.View.extend({
  id: "tournament-create-view",
  className: "create-view",
  template: _.template($("#tournament-create-view-template").html()),
  events: {
    "click .create.button": "submit",
    "click .cancel.button": "cancel",
  },

  getInputData: function () {
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

    let input_data = {};
    input_field.forEach(
      (column) =>
        (input_data[column.replaceAll("-", "_")] = this.$(
          `input[name=${column}]`
        ).val())
    );
    select_field.forEach(
      (column) =>
        (input_data[column.replaceAll("-", "_")] = this.$(
          `.${column} option:selected`
        ).val())
    );
    Object.keys(input_data).map(function (key) {
      if (input_data[key] == "") input_data[key] = null;
    });
    return input_data;
  },

  submit: function () {
    let input_data = this.getInputData();
    Helper.fetch("tournaments", {
      method: "POST",
      body: {
        tournament: input_data,
      },
      success_callback: () => App.router.navigate("#/tournaments"),
      fail_callback: (data) => Helper.info({ error: data.error }),
    });
  },

  cancel: function () {
    Backbone.history.history.back();
  },

  getMaxDate: function () {
    let now = new Date();
    now.setDate(now.getDate() + 60);
    const max_iso_time = now.getTime() - now.getTimezoneOffset() * 60000;
    return new Date(max_iso_time).toISOString().substr(0, 10);
  },

  getMinDate: function () {
    let now = new Date();
    now.setDate(now.getDate() + 1);
    const min_iso_time = now.getTime() - now.getTimezoneOffset() * 60000;
    return new Date(min_iso_time).toISOString().substr(0, 10);
  },

  render: function () {
    const min_date = this.getMinDate();
    const max_date = this.getMaxDate();
    this.$el.html(
      this.template({
        min_date: min_date,
        max_date: max_date,
      })
    );
    return this;
  },

  close: function () {
    this.remove();
  },
});
