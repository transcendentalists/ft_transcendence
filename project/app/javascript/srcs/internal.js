/* CONFIGURATION AND UTIL */
import { Helper } from "./helpers/helper";
export { Helper } from "./helpers/helper";
import { DualHelper } from "./helpers/dual_helper";
export { DualHelper } from "./helpers/dual_helper";
import { Router } from "./config/router";
import { AppView } from "./views/app_view";

import consumer from "channels/consumer";

/* SERVICE MODEL */
import { AdminDB } from "./models/admin_db";
import { ChatBan } from "./models/chat_ban";
import { ChatMessage } from "./models/chat_message";
import { CurrentUser } from "./models/current_user";
import { User } from "./models/user";

/* GAME MODEL */
import { GameBall } from "./models/game/game_ball";
import { GameNet } from "./models/game/game_net";
import { GamePaddle } from "./models/game/game_paddle";
import { GameScore } from "./models/game/game_score";

/* COLLECTION */
import { ChatBans } from "./collections/chat_bans";
import { DirectChatMessages } from "./collections/direct_chat_messages";
import { Friends } from "./collections/friends";
import { GroupChatMembers } from "./collections/group_chat_members";
import { GroupChatMessages } from "./collections/group_chat_messages";
import { Users } from "./collections/users";

/* CHANNEL */
import { ConnectAppearanceChannel } from "channels/appearance_channel";
import { ConnectDirectChatChannel } from "channels/direct_chat_channel";
import { ConnectGameChannel } from "channels/game_channel";
import { ConnectGroupChatChannel } from "channels/group_chat_channel";
import { ConnectWarChannel } from "channels/war_channel";
import { ConnectNotificationChannel } from "channels/notification_channel";

/* VIEW */

/** admin views */
import { AdminIndexView } from "./views/admin/admin_index_view";
import { AdminSelectView } from "./views/admin/admin_select_view";

/** appearance views */
import { AppearanceView } from "./views/appearance/appearance_view";
import { FriendsListView } from "./views/appearance/friends_list_view";
import { MainButtonsView } from "./views/appearance/main_buttons_view";
import { OnlineUserListView } from "./views/appearance/online_user_list_view";
import { UserMenuView } from "./views/appearance/user_menu_view";
import { UserUnitView } from "./views/appearance/user_unit_view";

/** group chat views */
import { ChatIndexView } from "./views/chat/chat_index_view";
import { ChatMessageView } from "./views/chat/chat_message_view";
import { ChatRoomCardListView } from "./views/chat/chat_room_card_list_view";
import { ChatRoomCardView } from "./views/chat/chat_room_card_view";
import { ChatRoomCreateView } from "./views/chat/chat_room_create_view";
import { ChatRoomMemberListView } from "./views/chat/chat_room_member_list_view";
import { ChatRoomMemberMenuView } from "./views/chat/chat_room_member_menu_view";
import { ChatRoomMemberUnitView } from "./views/chat/chat_room_member_unit_view";
import { ChatRoomMenuView } from "./views/chat/chat_room_menu_view";
import { ChatRoomView } from "./views/chat/chat_room_view";
import { GroupChatMessageListView } from "./views/chat/group_chat_message_list_view";

/** direct chat views */
import { DirectChatMessageListView } from "./views/chat/direct_chat_message_list_view";
import { DirectChatRoomView } from "./views/chat/direct_chat_room_view";

/** error view */
import { ErrorView } from "./views/error/error_view";

/** game views */
import { GameIndexView } from "./views/game/game_index_view";
import { GamePlayView } from "./views/game/game_play_view";
import { MatchHistoryListView } from "./views/game/match_history_list_view";
import { MatchHistoryView } from "./views/game/match_history_view";

/** guild views */
import { GuildCreateView } from "./views/guild/guild_create_view";
import { GuildDetailView } from "./views/guild/guild_detail_view";
import { GuildIndexView } from "./views/guild/guild_index_view";
import { GuildInvitationListView } from "./views/guild/guild_invitation_list_view";
import { GuildInvitationView } from "./views/guild/guild_invitation_view";
import { GuildMemberCardButtonsView } from "./views/guild/guild_member_card_buttons_view";
import { GuildMemberListView } from "./views/guild/guild_member_list_view";
import { GuildMemberProfileCardView } from "./views/guild/guild_member_profile_card_view";
import { GuildProfileCardButtonsView } from "./views/guild/guild_profile_card_buttons_view";
import { GuildProfileCardView } from "./views/guild/guild_profile_card_view";
import { GuildRankingView } from "./views/guild/guild_ranking_view";

/** ladder views */
import { LadderIndexView } from "./views/ladder/ladder_index_view";
import { MyRatingView } from "./views/ladder/my_rating_view";
import { UserRankingView } from "./views/ladder/user_ranking_view";

/** live views */
import { LiveCardListView } from "./views/live/live_card_list_view";
import { LiveCardView } from "./views/live/live_card_view";
import { LiveIndexView } from "./views/live/live_index_view";

/** persist views */
import { AlertModalView } from "./views/persist/alert_modal_view";
import { DirectChatView } from "./views/persist/direct_chat_view";
import { ImageUploadModalView } from "./views/persist/image_upload_modal_view";
import { InfoModalView } from "./views/persist/info_modal_view";
import { InputModalView } from "./views/persist/input_modal_view";
import { InviteView } from "./views/persist/invite_view";
import { MainView } from "./views/persist/main_view";
import { NavBarView } from "./views/persist/nav_bar_view";
import { RequestView } from "./views/persist/request_view";
import { RuleModalView } from "./views/persist/rule_modal_view";

/** registration views */
import { SignInView } from "./views/registration/sign_in_view";
import { SignUpView } from "./views/registration/sign_up_view";

/** share views */
import { TableModalView } from "./views/share/table_modal_view";

/** tournaments views */
import { TournamentCardListView } from "./views/tournament/tournament_card_list_view";
import { TournamentCardView } from "./views/tournament/tournament_card_view";
import { TournamentCreateView } from "./views/tournament/tournament_create_view";
import { TournamentIndexView } from "./views/tournament/tournament_index_view";
import { TournamentMatchCardListView } from "./views/tournament/tournament_match_card_list_view";
import { TournamentMatchCardView } from "./views/tournament/tournament_match_card_view";

/** user views */
import { UserIndexButtonsView } from "./views/user/user_index_buttons_view";
import { UserIndexView } from "./views/user/user_index_view";
import { UserProfileCardView } from "./views/user/user_profile_card_view";

/** war views */
import { WarCreateView } from "./views/war/war_create_view";
import { WarHistoryListView } from "./views/war/war_history_list_view";
import { WarHistoryView } from "./views/war/war_history_view";
import { WarIndexView } from "./views/war/war_index_view";
import { WarRequestCardListView } from "./views/war/war_request_card_list_view";
import { WarRequestCardView } from "./views/war/war_request_card_view";
import { WarRequestDetailModalView } from "./views/war/war_request_detail_modal_view";

export let App = {
  start: function () {
    Helper.fetch("session", { method: "DELETE" });
    this.resources = {
      chat_bans: new App.Collection.ChatBans(),
    };
    this.consumer = consumer;
    this.app_view = new AppView();
    this.current_user = new CurrentUser();
    this.main_view = App.app_view.main_view;
    this.router = new Router();
  },

  restart: function () {
    this.consumer.subscriptions.subscriptions.forEach((subscription) =>
      subscription.unsubscribe()
    );
    this.consumer.disconnect();
    this.app_view.restart();
    this.current_user = new CurrentUser();
    this.router.navigate("#/sessions/new");
  },

  Model: {
    AdminDB,
    ChatBan,
    ChatMessage,
    CurrentUser,
    User,
    GameBall,
    GameNet,
    GamePaddle,
    GameScore,
  },
  Collection: {
    ChatBans,
    DirectChatMessages,
    Friends,
    GroupChatMembers,
    GroupChatMessages,
    Users,
  },
  View: {
    AdminIndexView,
    AdminSelectView,
    AppearanceView,
    FriendsListView,
    MainButtonsView,
    OnlineUserListView,
    UserMenuView,
    UserUnitView,
    ChatIndexView,
    ChatMessageView,
    ChatRoomCardListView,
    ChatRoomCardView,
    ChatRoomCreateView,
    ChatRoomMemberListView,
    ChatRoomMemberMenuView,
    ChatRoomMemberUnitView,
    ChatRoomMenuView,
    ChatRoomView,
    DirectChatMessageListView,
    DirectChatRoomView,
    GroupChatMessageListView,
    ErrorView,
    GameIndexView,
    GamePlayView,
    MatchHistoryListView,
    MatchHistoryView,
    GuildCreateView,
    GuildDetailView,
    GuildIndexView,
    GuildInvitationListView,
    GuildInvitationView,
    GuildMemberCardButtonsView,
    GuildMemberListView,
    GuildMemberProfileCardView,
    GuildProfileCardButtonsView,
    GuildProfileCardView,
    GuildRankingView,
    LadderIndexView,
    MyRatingView,
    UserRankingView,
    LiveCardListView,
    LiveCardView,
    LiveIndexView,
    AlertModalView,
    DirectChatView,
    ImageUploadModalView,
    InfoModalView,
    InputModalView,
    InviteView,
    MainView,
    NavBarView,
    RequestView,
    RuleModalView,
    SignInView,
    SignUpView,
    TableModalView,
    TournamentCardListView,
    TournamentCardView,
    TournamentCreateView,
    TournamentIndexView,
    TournamentMatchCardListView,
    TournamentMatchCardView,
    UserIndexButtonsView,
    UserIndexView,
    UserProfileCardView,
    WarCreateView,
    WarHistoryListView,
    WarHistoryView,
    WarIndexView,
    WarRequestCardListView,
    WarRequestCardView,
    WarRequestDetailModalView,
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
