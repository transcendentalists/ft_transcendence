import { App } from "srcs/internal";

export let ChatRoomMemberListView = Backbone.View.extend({
  el: "#chat-room-member-list-view",

  events: {
    "click .user-unit": "openMemberMenu",
    mouseleave: "hideMemberMenu",
  },

  initialize: function (options) {
    this.parent = options.parent;
    this.chat_bans = App.resources.chat_bans;
    this.chat_room_members = this.parent.chat_room_members;
    this.child_views = [];
    this.chat_member_menu_view = null;

    this.listenTo(this.chat_room_members, "restore", this.addOne);
  },

  addOne: function (member) {
    if (member.get("position") == "ghost") return;
    let member_unit_view = new App.View.ChatRoomMemberUnitView({
      model: member,
      parent: this,
    });
    this.child_views.push(member_unit_view);
    this.$el.append(member_unit_view.render().$el);
  },

  addAll: function () {
    this.child_views.forEach((child_view) => child_view.close());
    this.chat_room_members.forEach(function (member) {
      if (member.position != "ghost") this.addOne(member);
    }, this);
  },

  render: function () {
    this.addAll();
    this.listenTo(this.chat_room_members, "add", this.addOne);

    this.chat_member_menu_view = new App.View.ChatRoomMemberMenuView(this);
    this.chat_member_menu_view.setElement($("#chat-room-member-menu-view"));
  },

  openMemberMenu: function (event) {
    const client_x = event.clientX;
    const client_y = event.clientY;
    const member_id = event.target
      .closest(".chat-member-unit")
      .getAttribute("data-user-id");
    const member = this.chat_room_members.get(member_id);
    const options = { member, client_x, client_y };
    this.chat_member_menu_view.render(options);
  },

  hideMemberMenu: function (event) {
    if (
      event.target.id != "chat-room-member-list-view" &&
      event.target.id != "chat-room-right-area"
    )
      return;
    if (this.chat_member_menu_view) this.chat_member_menu_view.hide();
  },

  close: function () {
    if (this.chat_member_menu_view) this.chat_member_menu_view.close();
    if (this.online_user_list_view) this.online_user_list_view.close();
    if (this.friends_list_view) this.friends_list_view.close();
    this.remove();
  },
});
