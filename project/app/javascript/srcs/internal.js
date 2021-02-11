/* MODEL */
import { User } from "./models/user";
import { CurrentUser } from "./models/current_user";
import { GameNet } from "./models/game_net";
import { GameBall } from "./models/game_ball";
import { GameScore } from "./models/game_score";
import { GamePaddle } from "./models/game_paddle";

/* COLLECTION */
import { Users } from "./collections/users";

/* VIEW */

/** registration views */
import { SignInView } from "./views/registration/sign_in_view";
import { SignUpView } from "./views/registration/sign_up_view";

/** persist views */
import { MainView } from "./views/persist/main_view";
import { AppearanceView } from "./views/persist/appearance_view";
import { AlertModalView } from "./views/persist/alert_modal_view";
import { DirectChatView } from "./views/persist/direct_chat_view";
import { InfoModalView } from "./views/persist/info_modal_view";
import { InputModalView } from "./views/persist/input_modal_view";
import { ImageUploadModalView } from "./views/persist/image_upload_modal_view";
import { InviteView } from "./views/persist/invite_view";
import { NavBarView } from "./views/persist/nav_bar_view";

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

import { ChatIndexView } from "./views/chat/chat_index_view";
import { ChatRoomView } from "./views/chat/chat_room_view";
import { ChatRoomCreateView } from "./views/chat/chat_room_create_view";
import { GuildIndexView } from "./views/guild/guild_index_view";
import { GuildDetailView } from "./views/guild/guild_detail_view";
import { GuildCreateView } from "./views/guild/guild_create_view";
import { UserProfileCardView } from "./views/user/user_profile_card_view";
import { LiveIndexView } from "./views/live/live_index_view";
import { WarIndexView } from "./views/war/war_index_view";
import { WarCreateView } from "./views/war/war_create_view";
import { TournamentIndexView } from "./views/tournament/tournament_index_view";
import { TournamentCreateView } from "./views/tournament/tournament_create_view";
import { AdminUserIndexView } from "./views/admin/admin_user_index_view";
import { AdminChatIndexView } from "./views/admin/admin_chat_index_view";
import { AdminChatRoomView } from "./views/admin/admin_chat_room_view";
import { AdminGuildIndexView } from "./views/admin/admin_guild_index_view";
import { AdminGuildDetailView } from "./views/admin/admin_guild_detail_view";

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
import { Router } from "./router";
import { AppView } from "./views/app_view";
import consumer from "channels/consumer";

export let App = {
  initialize: function () {
    Helper.fetch("session", { method: "DELETE" });
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
    Helper.fetch(`users/${this.current_user.get("id")}/session`, {
      method: "DELETE",
    });
    this.current_user.reset(true);
    this.appView.restart();
    this.router.navigate("#/sessions/new");
  },

  Model: {
    User,
    CurrentUser,
    GameNet,
    GameBall,
    GameScore,
    GamePaddle,
  },
  Collection: {
    Users,
  },
  View: {
    SignInView,
    SignUpView,
    AppearanceView,

    MainView,
    AlertModalView,
    DirectChatView,
    ErrorView,
    InfoModalView,
    InputModalView,
    ImageUploadModalView,
    InviteView,
    NavBarView,

    UserIndexView,
    UserIndexButtonsView,

    ChatIndexView,
    ChatRoomView,
    ChatRoomCreateView,
    GuildIndexView,
    GuildDetailView,
    GuildCreateView,
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
