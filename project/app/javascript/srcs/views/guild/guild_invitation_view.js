import { Helper } from "srcs/internal";

/**
 ** my_rating_view 혹은 user_ranking_view에 의해
 ** 전달되는 데이터를 렌더링하는 역할로 이벤트 감지 없음
 */

export let GuildInvitationView = Backbone.View.extend({
  template: _.template($("#guild-invitation-view-template").html()),

  initialize: function () {},

  render: function (data) {
    this.$el.html(
      this.template({
        guild: {
          image_url: "assets/eunhkim1.png",
          name: "eunhkim",
          anagram: "anagram",
        },
        sender: "sanam",
        receiver: "receiver",
      })
    );
    return this;
  },

  close: function () {
    this.$el.empty();
    this.$el.remove();
  },
});
