import { App } from "srcs/internal";

export let ChatRoomMemberListView = Backbone.View.extend({
  el: "#chat-room-member-list-view",

  events: {},

  initialize: function (options) {
    this.parent = options.parent;
    this.chat_bans = App.resources.chat_bans;
    this.chat_room_members = this.parent.chat_room_members;
    this.child_views = [];
  },

  render: function () {
    this.addAll();
    return this;
  },

  addOne: function (member) {
    let member_unit_view = new App.View.ChatRoomMemberUnitView({
      model: member,
      parent: this,
    });
    this.child_views.push(member_unit_view);
    this.$el.append(member_unit_view.render().$el);
  },

  addAll: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.chat_room_members.forEach((member) => this.addOne(member));
  },

  close: function () {
    this.online_user_list_view.close();
    this.friends_list_view.close();
    this.remove();
  },
});
