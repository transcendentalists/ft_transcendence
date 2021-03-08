export let WarStatusView = Backbone.View.extend({
  template: _.template($("#war-status-view-template").html()),

  initialize: function () {},

  render: function (war_status) {
    this.$el.html(this.template(war_status));

    let dataset = document.getElementById("challenger-point");
    document.getElementById("challenger-point").dataset.value = war_status.my_guild_point;
    document.getElementById("enemy-point").dataset.value = war_status.opponent_guild_point;
    document.getElementById("remained-no-reply-count").dataset.value = war_status.remained_no_reply_count;

    $('#challenger-point').progress({label: 'ratio', text: { ratio: '{value}P' }});
    $('#enemy-point').progress({label: 'ratio', text: { ratio: '{value}P' }});
    $('#remained-no-reply-count').progress({label: 'ratio', text: { ratio: '{value}회/{total}회' }});

    return this;
  },

  close: function () {
    this.remove();
  },
});
