/* MODEL */
import { User } from "./models/user";
import { CurrentUser } from "./models/current_user";
import { GameNet } from "./models/game_net";
import { GameBall } from "./models/game_ball";
import { GameScore } from "./models/game_score";
import { GamePaddle } from "./models/game_paddle";
import { ChatBan } from "./models/chat_ban";
import { ChatMessage } from "./models/chat_message";

/* COLLECTION */
import { Users } from "./collections/users";
import { Friends } from "./collections/friends";
import { ChatBans } from "./collections/chat_bans";
import { ChatMessages } from "./collections/chat_messages";
import { GroupChatMessages } from "./collections/group_chat_messages";
import { GroupChatMembers } from "./collections/group_chat_members";

/* VIEW */

/** registration views */
import { SignInView } from "./views/registration/sign_in_view";
import { SignUpView } from "./views/registration/sign_up_view";

/** persist views */
import { MainView } from "./views/persist/main_view";
import { AppearanceView } from "./views/persist/appearance/appearance_view";
import { AlertModalView } from "./views/persist/alert_modal_view";
import { InfoModalView } from "./views/persist/info_modal_view";
import { InputModalView } from "./views/persist/input_modal_view";
import { ImageUploadModalView } from "./views/persist/image_upload_modal_view";
import { InviteView } from "./views/persist/invite_view";
import { RequestView } from "./views/persist/request_view";
import { NavBarView } from "./views/persist/nav_bar_view";
import { RuleModalView } from "./views/persist/rule_modal_view";

/** error view */
import { ErrorView } from "./views/error/error_view";

/** user views */
import { UserIndexView } from "./views/user/user_index_view";
import { UserIndexButtonsView } from "./views/user/user_index_buttons_view";
import { GuildInvitationView } from "./views/guild/guild_invitation_view";
import { GuildInvitationListView } from "./views/guild/guild_invitation_list_view";
import { MatchHistoryView } from "./views/game/match_history_view";
import { MatchHistoryListView } from "./views/game/match_history_list_view";

/** ladder views */
import { LadderIndexView } from "./views/ladder/ladder_index_view";
import { MyRatingView } from "./views/ladder/my_rating_view";
import { UserRankingView } from "./views/ladder/user_ranking_view";

/** game views */
import { GameIndexView } from "./views/game/game_index_view";
import { GamePlayView } from "./views/game/game_play_view";

/** appearance views */
import { FriendsListView } from "./views/persist/appearance/friends_list_view";
import { OnlineUserListView } from "./views/persist/appearance/online_user_list_view";
import { UserUnitView } from "./views/persist/appearance/user_unit_view";
import { UserMenuView } from "./views/persist/appearance/user_menu_view";

/** direct chat views */
import { DirectChatView } from "./views/persist/direct_chat_view";
import { DirectChatRoomView } from "./views/chat/direct_chat_room_view";
import { DirectChatMessageListView } from "./views/chat/direct_chat_message_list_view";
import { ChatMessageView } from "./views/chat/chat_message_view";

/** chat views */
import { ChatIndexView } from "./views/chat/chat_index_view";
import { ChatRoomCardListView } from "./views/chat/chat_room_card_list_view";
import { ChatRoomCardView } from "./views/chat/chat_room_card_view";
import { ChatRoomCreateView } from "./views/chat/chat_room_create_view";
import { ChatRoomView } from "./views/chat/chat_room_view";
import { ChatRoomMemberListView } from "./views/chat/chat_room_member_list_view";
import { ChatRoomMemberUnitView } from "./views/chat/chat_room_member_unit_view";
import { GroupChatMessageListView } from "./views/chat/group_chat_message_list_view";
import { ChatRoomMemberMenuView } from "./views/chat/chat_room_member_menu_view";
import { ChatRoomMenuView } from "./views/chat/chat_room_menu_view";

import { UserProfileCardView } from "./views/user/user_profile_card_view";
import { LiveIndexView } from "./views/live/live_index_view";

import { TournamentIndexView } from "./views/tournament/tournament_index_view";
import { TournamentCreateView } from "./views/tournament/tournament_create_view";
import { AdminUserIndexView } from "./views/admin/admin_user_index_view";
import { AdminChatIndexView } from "./views/admin/admin_chat_index_view";
import { AdminChatRoomView } from "./views/admin/admin_chat_room_view";
import { AdminGuildIndexView } from "./views/admin/admin_guild_index_view";
import { AdminGuildDetailView } from "./views/admin/admin_guild_detail_view";

/** guild views */
import { GuildIndexView } from "./views/guild/guild_index_view";
import { GuildDetailView } from "./views/guild/guild_detail_view";
import { GuildCreateView } from "./views/guild/guild_create_view";
import { GuildProfileCardView } from "./views/guild/guild_profile_card_view";
import { GuildProfileCardButtonsView } from "./views/guild/guild_profile_card_buttons_view";
import { GuildRankingView } from "./views/guild/guild_ranking_view";
import { GuildMemberRankingView } from "./views/guild/guild_member_ranking_view";
import { GuildMemberListButtonsView } from "./views/guild/guild_member_list_buttons_view";

/** war views */
import { WarRequestCardListView } from "./views/war/war_request_card_list_view";
import { WarRequestCardView } from "./views/war/war_request_card_view";
import { WarIndexView } from "./views/war/war_index_view";
import { WarCreateView } from "./views/war/war_create_view";
import { WarHistoryListView } from "./views/war/war_history_list_view";
import { WarHistoryView } from "./views/war/war_history_view";
import { WarRequestDetailModalView } from "./views/war/war_request_detail_modal_view";

/* CHANNEL */
import { ConnectAppearanceChannel } from "channels/appearance_channel";
import { ConnectDirectChatChannel } from "channels/direct_chat_channel";
import { ConnectGameChannel } from "channels/game_channel";
import { ConnectGroupChatChannel } from "channels/group_chat_channel";
import { ConnectWarChannel } from "channels/war_channel";
import { ConnectNotificationChannel } from "channels/notification_channel";

/* CONFIGURATION AND UTIL */
import { Helper } from "./helper";
export { Helper } from "./helper";
import { DualHelper } from "./dual_helper";
export { DualHelper } from "./dual_helper";
import { Router } from "./router";
import { AppView } from "./views/app_view";

import consumer from "channels/consumer";

export let App = {
  initialize: function () {
    Helper.fetch("session", { method: "DELETE" });
    this.resources = {
      chat_bans: new App.Collection.ChatBans(),
    };
    this.appView = new AppView();
    this.router = new Router();
    this.mainView = App.appView.main_view;
    this.current_user = new CurrentUser();
    this.consumer = consumer;
  },

  restart: function () {
    this.consumer.subscriptions.subscriptions.forEach((subscription) =>
      subscription.unsubscribe()
    );
    this.consumer.disconnect();
    this.appView.restart();
    this.current_user.logout();
    this.current_user = new CurrentUser();
    this.router.navigate("#/sessions/new");
  },

  Model: {
    User,
    CurrentUser,
    ChatBan,
    ChatMessage,
    GameNet,
    GameBall,
    GameScore,
    GamePaddle,
  },
  Collection: {
    Users,
    Friends,
    ChatBans,
    ChatMessages,
    GroupChatMessages,
    GroupChatMembers,
  },
  View: {
    SignInView,
    SignUpView,
    AppearanceView,

    MainView,
    AlertModalView,
    DirectChatView,
    DirectChatRoomView,
    ErrorView,
    InfoModalView,
    InputModalView,
    ImageUploadModalView,
    InviteView,
    RequestView,
    NavBarView,
    RuleModalView,

    UserIndexView,
    UserIndexButtonsView,
    DirectChatMessageListView,
    ChatMessageView,

    ChatIndexView,
    ChatRoomCardListView,
    ChatRoomCardView,
    ChatRoomView,
    ChatRoomMenuView,
    ChatRoomMemberListView,
    ChatRoomMemberUnitView,
    ChatRoomMemberMenuView,
    ChatRoomCreateView,
    GroupChatMessageListView,
    GuildIndexView,
    GuildDetailView,
    GuildCreateView,
    GuildProfileCardView,
    GuildProfileCardButtonsView,
    GuildRankingView,
    GuildMemberRankingView,
    GuildMemberListButtonsView,

    WarHistoryListView,
    WarHistoryView,
    WarRequestCardListView,
    WarRequestCardView,
    WarRequestDetailModalView,
    GuildInvitationView,
    GuildInvitationListView,
    LadderIndexView,
    UserRankingView,
    UserProfileCardView,
    MyRatingView,
    LiveIndexView,
    WarIndexView,
    WarCreateView,
    GameIndexView,
    GamePlayView,
    MatchHistoryView,
    MatchHistoryListView,
    TournamentIndexView,
    TournamentCreateView,
    AdminUserIndexView,
    AdminChatIndexView,
    AdminChatRoomView,
    AdminGuildIndexView,
    AdminGuildDetailView,
    FriendsListView,
    OnlineUserListView,
    UserUnitView,
    UserMenuView,
  },
  Channel: {
    ConnectAppearanceChannel,
    ConnectDirectChatChannel,
    ConnectGameChannel,
    ConnectGroupChatChannel,
    ConnectNotificationChannel,
    ConnectWarChannel,
  },
};
