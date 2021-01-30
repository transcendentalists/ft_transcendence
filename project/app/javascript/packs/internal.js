import { User } from "./models/user";
import { Users } from "./collections/users";
import { AppView } from "./views/app_view";
import { MyRatingView } from "./views/my_rating_view";
import { UserRankingView } from "./views/user_ranking_view";
import { UserProfileCardView } from "./views/user_profile_card_view";
import { LadderIndexView } from "./views/ladder_index_view";
import { MainView } from "./views/main_view";

export let App = {
  Model: {
    User,
  },
  Collection: {
    Users,
  },
  View: {
    AppView,
    MainView,
    LadderIndexView,
    UserRankingView,
    UserProfileCardView,
    MyRatingView,
  },
};

window.app = App;
// export { router } from "./router";
// export { AppView } from "./views/app-view";
// export { NavView } from "./views/nav-view";
// export { SideBarView } from "./views/side-bar-view";
// export { HomeView } from "./views/home-view";
// export { ChatView } from './views/chat-view'
// export { GuildView } from './views/guild-view'
// export { GameView } from './views/game-view'
// export { IsLoggedIn } from './helper'
// export { SigninView } from './views/signin-view'
// export { SignupView } from './views/signup-view'
// export { User } from "./models/user";
// export { Users } from "./collections/users";
// export { Users } from './collections/users'
// export { UserStatusView } from './views/user_status_view'
// export { connectSideBarChannel } from '../channels/side_bar_channel.js'
