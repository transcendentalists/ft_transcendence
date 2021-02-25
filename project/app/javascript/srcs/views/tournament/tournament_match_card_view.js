export let TournamentMatchCardView = Backbone.View.extend({
  template: _.template($("#tournament-match-card-view-template").html()),
  className: "tournament-match-card",

  initialize: function () {},

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
    this.$el.empty();
    this.remove();
  },
});
