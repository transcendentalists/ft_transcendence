import { App } from "srcs/internal";

export let GuildInvitationListView = Backbone.View.extend({
  el: "#guild-invitation-list-view",
  defaultText: "<span>초대장이 도착하기를 기다리고 있습니다.</span>",

  initialize: function () {
    this.child_views = [];
  },

  render: function (guild_invitations) {
    this.$el.empty();
    if (!guild_invitations.length) this.renderDefaultText();
    else guild_invitations.forEach(this.addOne, this);
    return this;
  },

  renderDefaultText: function () {
    this.$el.html(this.defaultText);
  },

  addOne: function (guild_invitation) {
    let guild_invitation_view = new App.View.GuildInvitationView();
    this.listenTo(guild_invitation_view, "decline", () =>
      this.trigger("decline")
    );
    this.child_views.push(guild_invitation_view);
    this.$el.append(guild_invitation_view.render(guild_invitation).$el);
  },

  close: function () {
    this.child_views.forEach((guild_invitation_view) =>
      guild_invitation_view.close()
    );
    this.child_views = [];
    this.remove();
  },
});
