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
    const max = new Date();
    max.setDate(max.getDate() + 60);
    const month =
      max.getMonth() < 9 ? "0" + (max.getMonth() + 1) : max.getMonth() + 1 + "";
    const date = max.getDate() < 10 ? "0" + max.getDate() : max.getDate() + "";
    return max.getFullYear() + "-" + month + "-" + date;
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
