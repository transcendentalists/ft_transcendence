import { App } from "srcs/internal";

export let TournamentMatchCardView = Backbone.View.extend({
  template: _.template($("#tournament-match-card-view-template").html()),
  className: "tournament-match-card",

  events: {
    "click .play.button": "play",
  },

  play: function (event) {
    let match_id = event.target.getAttribute("data-match-id");
    if (isNaN(match_id)) return;

    App.router.navigate(`#/matches?match_type=tournament&match_id=${match_id}`);
  },

  initialize: function () {},

  /**
   ** 경기 시간이 10분(600,000ms) 내로 남았을 경우 참여가능
   */
  render: function (data) {
    let content = data.current_user_next_match;
    content.title = data.title;
    const present = new Date();
    const match_time = new Date(content.start_datetime);
    content.can_play_at_now =
      present < match_time && match_time - present < 600000;

    this.$el.html(this.template(content));
    return this;
  },

  close: function () {
    this.remove();
  },
});
