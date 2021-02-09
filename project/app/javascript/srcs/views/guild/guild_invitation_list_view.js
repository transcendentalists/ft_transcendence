import { App } from "srcs/internal";

export let GuildInvitationListView = Backbone.View.extend({
  id: "guild-invitation-list",
  className: "ui text container",

  initialize: function () {
    this.child_views = [];
  },

  addOne: function (user) {
    let child_view = new App.View.GuildInvitationView();
    this.child_views.push(child_view);
    this.$el.append(child_view.render(user).$el);
  },

  render: function (users_data) {
    this.$el.html(this.template());
    users_data.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views = [];
    this.remove();
  },
});
