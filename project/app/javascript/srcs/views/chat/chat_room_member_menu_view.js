import { App, Helper, DualHelper } from "srcs/internal";

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
    this.friends = App.resources.friends;
    this.online_users = App.resources.online_users;
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

  menuAction: function (e) {
    const event = e.target.getAttribute("data-event-name");
    const member = this.parent.chat_room_members.get(this.member.id);
    const params = {
      current_user: this.current_user_membership,
      member: member,
    };

    this.hide();
    switch (event) {
      case "direct-chat":
        return App.app_view.direct_chat_view.render(member);
      case "toggle-ban":
        return this.chat_bans.createOrDestroyChatBan(member.id);
      case "toggle-friend":
        return this.toggleFriendship();
      case "battle":
        return App.current_user.dualRequestTo(member);
      case "give-admin-position":
        return this.chat_members.giveAdminPosition(params);
      case "remove-admin-position":
        return this.chat_members.removeAdminPosition(params);
      case "toggle-mute":
        return this.chat_members.toggleMute(params);
      case "kick":
        return this.chat_members.letOutOfChatRoom(member);
      default:
    }
  },

  createFriend: function (user_id) {
    let user = Helper.getUser(user_id);
    if (user !== undefined) {
      this.friends.createFriendship(user);
      this.online_users.remove(user);
    } else {
      Helper.fetch(`users/${user_id}?for=appearance`, {
        success_callback: function (data) {
          let user = new App.Model.User(data.user);
          this.friends.createFriendship(user);
        }.bind(this),
      });
    }
  },

  destroyFriend: function (friend_id) {
    let friend = Helper.getUser(friend_id);
    this.friends.destroyFriendship(friend);
  },

  toggleFriendship: function () {
    const user_id = this.member.id;
    const friend = this.friends.get(user_id);

    if (friend == undefined) this.createFriend(user_id);
    else this.destroyFriend(user_id);
    this.hide();
  },

  hide: function () {
    if (this.$el.css("display") == "none") return;
    this.$el.empty();
    this.$el.css("display", "none");
  },

  close: function () {
    this.hide();
    $(this.menu).off();
    this.remove();
  },
});
