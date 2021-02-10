import { App } from "srcs/internal";

export let GuildInvitationListView = Backbone.View.extend({
  el: "#guild-invitation-list",

  initialize: function () {
    this.child_views = [];
  },

  addOne: function (user) {
    let child_view = new App.View.GuildInvitationView();
    this.child_views.push(child_view);
    this.$el.append(child_view.render(user).$el);
  },

  render: function () {
    let users_data = [
      {
        guild: {
          image_url: "assets/eunhkim1.png",
          name: "42 gon guild",
          anagram: "GON",
        },
        sender: "sanam",
        receiver: "eunhkim",
      },
      {
        guild: {
          image_url: "assets/eunhkim1.png",
          name: "42 gon guild",
          anagram: "GON",
        },
        sender: "sanam",
        receiver: "eunhkim",
      },
      {
        guild: {
          image_url: "assets/eunhkim1.png",
          name: "42 gon guild",
          anagram: "GON",
        },
        sender: "sanam",
        receiver: "eunhkim",
      },
      {
        guild: {
          image_url: "assets/eunhkim1.png",
          name: "42 gon guild",
          anagram: "GON",
        },
        sender: "sanam",
        receiver: "eunhkim",
      },
      {
        guild: {
          image_url: "assets/sanam1.png",
          name: "42 gan guild",
          anagram: "GAM",
        },
        sender: "jujeong",
        receiver: "sanam",
      },
    ];
    users_data.forEach(this.addOne, this);
    return this;
  },

  close: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.child_views = [];
    this.remove();
  },
});
