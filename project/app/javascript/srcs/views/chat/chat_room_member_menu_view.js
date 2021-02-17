import { App } from "srcs/internal";
import { Helper } from "srcs/helper";

export let ChatRoomMemberMenuView = Backbone.View.extend({
  el: "#chat-room-member-menu-view",
  template: _.template($("#chat-room-member-menu-view-template").html()),

  initialize: function (self) {
    this.parent = self;
    this.member = null;
    this.menu = "#chat-room-member-menu-view a.item[data-event-name]";
    this.chat_bans = self.chat_bans;
    this.chat_members = self.chat_room_members;
    this.current_user_membership = self.parent.current_user_membership;
    this.friends = App.appView.appearance_view.friends;
    this.online_users = App.appView.appearance_view.online_users;

    // this.is_friend = options.is_friend;
    // this.listenTo(
    //   App.appView.appearance_view,
    //   "destroy_user_menu_all",
    //   this.close
    // );
    // this.listenTo(window, "resize", this.close);
  },

  menuAction: function (e) {
    const event = e.target.getAttribute("data-event-name");
    const member = this.parent.chat_room_members.get(this.member.id);
    const params = {
      current_user: this.current_user_membership,
      member: member,
    };
    console.log(
      "🚀 ~ file: chat_room_member_menu_view.js ~ line 34 ~ params",
      params
    );

    this.hide();
    switch (event) {
      case "direct-chat":
        return App.appView.direct_chat_view.render(member);
      case "toggle-ban":
        return this.chat_bans.toggleChatBan(member.id);
      case "toggle-friend":
        return this.toggleFriendship();
      case "battle":
        return;
      // return App.current_user.dualRequestTo(this.user);
      case "give-admin-position":
        return this.chat_members.giveAdminPosition(params);
      case "remove-admin-position":
        return this.chat_members.removeAdminPosition(params);
      case "toggle-mute":
        return this.chat_members.toggleMute(params);
      case "kick":
      default:
    }
  },

  toggleFriendship: function () {
    const user_id = this.member.id;
    const friend = this.friends.get(user_id);

    if (friend == undefined) {
      this.friends.createFriendship(user_id);
      this.online_users.remove(user_id);
    } else {
      this.friends.destroyFriendship(user_id);
      this.online_users.add(friend);
    }
  },

  render: function (options) {
    this.member = options.member;
    if (this.member.id == App.current_user.id) return;
    this.$el.html(
      this.template({
        user: options.member.attributes,
        current_user_position: this.current_user_membership.get("position"),
        banned: Helper.isUserChatBanned(this.member.id),
        is_friend: Helper.isUserFriend(this.member.id),
      })
    );
    this.$el.css("position", "fixed");
    this.$el.css("top", options.client_y);
    this.$el.css("left", _.min([options.client_x, 80]));
    this.$el.css("z-index", 103);
    this.$el.css("display", "block");
    $(this.menu).on("click", this.menuAction.bind(this));
    return this;
  },

  hide: function () {
    if (this.$el.css("display") == "none") return;
    this.$el.empty();
    this.$el.css("display", "none");
    $(this.menu).off();
  },

  close: function () {
    this.hide();
    this.remove();
  },
});
