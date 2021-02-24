import { App, Helper } from "srcs/internal";

/**
 ** my_rating_view 혹은 user_ranking_view에 의해
 ** 전달되는 데이터를 렌더링하는 역할로 이벤트 감지 없음
 */

export let UserProfileCardView = Backbone.View.extend({
  template: _.template($("#user-profile-card-template").html()),
  className: "ui segment profile-card flex-container center-aligned",

  initialize: function () {
    this.guild_member_list_buttons_view = null;
    this.user = null;
  },

  refresh: function (guild) {
    this.user.guild = guild;
    this.guild_member_list_buttons_view.close();
    this.render(this.user, true);
  },

  renderGuildMemberButtons: function () {
    this.guild_member_list_buttons_view = new App.View.GuildMemberListButtonsView({ parent: this });
    this.guild_member_list_buttons_view
      .setElement(this.$("#guild-member-list-buttons-view"))
      .render(this.user);
  },
  
  render: function (user, guild_detail = false) {
    this.user = user;
    this.$el.html(this.template(this.user));
    if (guild_detail) this.renderGuildMemberButtons();
    return this;
  },

  close: function () {
    this.user = null;
    this.remove();
  },
});
