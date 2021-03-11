import { App, Helper } from "srcs/internal";

export let DualHelper = {
  getUserModelInAppearanceCollections: function (id) {
    return (
      App.appView.appearance_view.friends.get(id) ||
      App.appView.appearance_view.online_users.get(id)
    );
  },

  showInfoMatchImpossibleAndClose: function (user_model) {
    if (
      this.el.id == "rule-modal-view" ||
      user_model.get("status") == "offline"
    ) {
      Helper.info({
        subject: "게임 진행 불가능",
        description: "상대방이 게임 진행이 불가능한 상태입니다.",
      });
      this.close();
    }
  },

  addListenToUserModel: function (view, user_id) {
    let user_model = this.getUserModelInAppearanceCollections(user_id);

    if (user_model == undefined || user_model.get("status") == "offline") {
      return false;
    }
    view.listenTo(
      user_model,
      "change:status",
      this.showInfoMatchImpossibleAndClose
    );

    return true;
  },
};
