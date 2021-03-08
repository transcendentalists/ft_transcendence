import { App } from "srcs/internal";

export let LiveCardView = Backbone.View.extend({
  template: _.template($("#live-card-view-template").html()),
  className: "live-card flex-container column-direction center-aligned",

  events: {
    "click .watch.button": "watchMatchLive",
  },

  initialize: function () {
    this.match_id = null;
  },

  url: function () {
    return `#/matches/${this.match_id}`;
  },

  watchMatchLive: function () {
    App.router.navigate(this.url());
  },

  title: function (match) {
    switch (match.type) {
      case "dual":
        return "듀얼";
      case "ladder":
        return "승급전";
      case "casual_ladder":
        return "친선전";
      case "tournament":
        return (
          match.tournament.title +
          " " +
          (match.tournament.round == 2 ? "결승" : match.tournament.round + "강")
        );
      case "war":
        return (
          match.guilds[0].anagram + " vs " + match.guilds[1].anagram + " 전쟁"
        );
    }
  },

  render: function (match) {
    this.match_id = match.id;
    match.title = this.title(match);
    this.$el.html(this.template(match));
    return this;
  },

  close: function () {
    this.remove();
  },
});
