import { App } from "srcs/internal";

export let ChatRoomMemberListView = Backbone.View.extend({
  el: "#chat-room-member-list-view",

  events: {
    "click .user-unit": "openMemberMenu",
    // "mouseleave .user-unit": "closeMemberMenu",
  },

  initialize: function (options) {
    this.parent = options.parent;
    this.chat_bans = App.resources.chat_bans;
    this.chat_room_members = this.parent.chat_room_members;
    this.child_views = [];
    this.chat_member_menu_view = null;
  },

  openMemberMenu: function (event) {
    console.log(event.clientX, event.clientY);
    const client_x = event.clientX;
    const client_y = event.clientY;
    const user = this.chat_room_members.get(
      event.target.getAttribute("data-user-id")
    );
    const options = { user, client_x, client_y };
    this.chat_member_menu_view.render(options);
  },

  // closeMemberMenu: function (event) {
  //   this.chat_member_menu_view.hide();
  //   console.log(
  //     "user id " +
  //       event.target.getAttribute("data-user-id") +
  //       "를 클릭 해제하셨습니다."
  //   );
  // },

  render: function () {
    this.addAll();
    this.chat_member_menu_view = new App.View.ChatRoomMemberMenuView(this);
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
    if (this.chat_member_menu_view) this.chat_member_menu_view.close();
    if (this.online_user_list_view) this.online_user_list_view.close();
    if (this.friends_list_view) this.friends_list_view.close();
    this.remove();
  },
});
