import { User } from "./models/user";
import { Users } from "./collections/users";
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

import { OnlineUserListView } from "./views/persist/appearance/online_user_list_view";
import { UserUnitView } from "./views/persist/appearance/user_unit_view";

import { Helper } from "./helper";
export { Helper } from "./helper";
import { Router } from "./router";
import { AppView } from "./views/app_view";
import { AlertModalView } from "./views/aside/alert_modal_view";
import { InfoModalView } from "./views/aside/info_modal_view";
import { InputModalView } from "./views/aside/input_modal_view";
import { ErrorView } from "./views/aside/error_view";

import { ConnectAppearanceChannel } from "../channels/appearance_channel";
import consumer from "../channels/consumer";

export let App = {
  initialize: function () {
    Helper.fetchContainer("session", { method: "DELETE" });
    this.appView = new AppView();
    this.router = new Router();
    this.mainView = App.appView.main_view;
    this.alertModalView = new AlertModalView();
    this.infoModalView = new InfoModalView();
    this.inputModalView = new InputModalView();
    this.errorView = new ErrorView();
    this.me = new App.Model.User({ isWebOwner: true });
    this.consumer = consumer;
  },

  restart: function () {
    this.consumer.subscriptions.subscriptions.forEach((subscription) =>
      subscription.unsubscribe()
    );
    this.consumer.disconnect();
    Helper.fetchContainer(`users/${App.me.get("id")}/session`, {
      method: "DELETE",
    });
    App.appView.restart();
    App.me.reset(true);
    App.router.navigate("#/sessions/new");
  },

  Model: {
    User,
  },
  Collection: {
    Users,
  },
  View: {
    SignInView,
    SignUpView,
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
    OnlineUserListView,
    UserUnitView,
  },
  Channel: {
    ConnectAppearanceChannel,
  },
};
window.app = App;
