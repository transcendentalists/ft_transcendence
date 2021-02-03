import { User } from "./models/user";
import { Users } from "./collections/users";
import { CurrentUser } from "./models/current_user";
import { SignInView } from "./views/registration/sign_in_view";
import { SignUpView } from "./views/registration/sign_up_view";
import { UserIndexView } from "./views/user/user_index_view";
import { ChatIndexView } from "./views/chat/chat_index_view";
import { ChatRoomView } from "./views/chat/chat_room_view";
import { ChatRoomCreateView } from "./views/chat/chat_room_create_view";
import { GuildIndexView } from "./views/guild/guild_index_view";
import { GuildDetailView } from "./views/guild/guild_detail_view";
import { GuildCreateView } from "./views/guild/guild_create_view";
import { LadderIndexView } from "./views/ladder/ladder_index_view";
import { UserProfileCardView } from "./views/user/user_profile_card_view";
import { MyRatingView } from "./views/ladder/my_rating_view";
import { UserRankingView } from "./views/ladder/user_ranking_view";
import { LiveIndexView } from "./views/live/live_index_view";
import { WarIndexView } from "./views/war/war_index_view";
import { WarCreateView } from "./views/war/war_create_view";
import { GameIndexView } from "./views/game/game_index_view";
import { TournamentIndexView } from "./views/tournament/tournament_index_view";
import { TournamentCreateView } from "./views/tournament/tournament_create_view";
import { AdminUserIndexView } from "./views/admin/admin_user_index_view";
import { AdminChatIndexView } from "./views/admin/admin_chat_index_view";
import { AdminChatRoomView } from "./views/admin/admin_chat_room_view";
import { AdminGuildIndexView } from "./views/admin/admin_guild_index_view";
import { AdminGuildDetailView } from "./views/admin/admin_guild_detail_view";
import { Helper } from "./helper";
export { Helper } from "./helper";
import { Router } from "./router";
import { AppView } from "./views/app_view";

// 영구뷰
import { MainView } from "./views/persist/main_view";
import { AppearanceView } from "./views/persist/appearance_view";
import { AlertModalView } from "./views/persist/alert_modal_view";
import { DirectChatView } from "./views/persist/direct_chat_view";
import { ErrorView } from "./views/error/error_view";
import { InfoModalView } from "./views/persist/info_modal_view";
import { InputModalView } from "./views/persist/input_modal_view";
import { InviteView } from "./views/persist/invite_view";
import { NavBarView } from "./views/persist/nav_bar_view";

import { AppearanceChannel } from "channels/appearance_channel";
import { DirectChatChannel } from "channels/direct_chat_channel";
import { GameChannel } from "channels/game_channel";
import { GroupChatChannel } from "channels/group_chat_channel";
import { WarChannel } from "channels/war_channel";
import { NotificationChannel } from "channels/notification_channel";

export let App = {
  initialize: function () {
    Helper.fetch("session", { method: "DELETE" });
    this.appView = new AppView();
    this.router = new Router();
    this.mainView = App.appView.main_view;
    this.current_user = new CurrentUser();
  },

  restart: function () {
    App.appView.restart();
    App.current_user.reset(true);
    App.router.navigate("#/sessions/new");
  },

  Model: {
    User,
    CurrentUser,
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
    InviteView,
    NavBarView,

    UserIndexView,
    ChatIndexView,
    ChatRoomView,
    ChatRoomCreateView,
    GuildIndexView,
    GuildDetailView,
    GuildCreateView,
    LadderIndexView,
    UserRankingView,
    UserProfileCardView,
    MyRatingView,
    LiveIndexView,
    WarIndexView,
    WarCreateView,
    GameIndexView,
    TournamentIndexView,
    TournamentCreateView,
    AdminUserIndexView,
    AdminChatIndexView,
    AdminChatRoomView,
    AdminGuildIndexView,
    AdminGuildDetailView,
  },
  Channel: {
    AppearanceChannel,
    DirectChatChannel,
    GameChannel,
    GroupChatChannel,
    NotificationChannel,
  },
};
window.app = App;
