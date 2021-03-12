import { App } from "srcs/internal";

export let Helper = {
  fetch: async function (url, hash_args = {}) {
    let params = {
      method: hash_args.method || "GET",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.getToken(),
        "Content-Type": "application/json",
        current_user: App.current_user?.id,
      },
    };

    const success_callback = hash_args.success_callback || null;
    const fail_callback = hash_args.fail_callback || null;

    if (hash_args.headers) {
      $.extend(params.headers, hash_args.headers);
      if (params.headers["Content-Type"] == "form-data")
        delete params.headers["Content-Type"];
    }
    if (hash_args.body) {
      let body = hash_args.body;
      params.body = params.headers["Content-Type"]
        ? JSON.stringify(body)
        : body;
    }

    const prefix = hash_args.prefix ? hash_args.prefix : "api/";
    let data = {};
    let success = false;

    try {
      let response = await fetch(prefix + url, params);
      success = response.ok;
      data = await response.json();
    } catch (err) {}

    if (!success && fail_callback) return fail_callback(data);
    if (success && success_callback) return success_callback(data);

    return data;
  },

  defaultSuccessHandler: function (action_name = "액션") {
    let immediate_action = false;
    if (typeof action_name !== "string") {
      immediate_action = true;
      action_name = "액션";
    }

    const prop =
      (action_name[action_name.length - 1].charCodeAt() - 0xac00) % 28 !== 0;
    const description = `요청하신 ${
      action_name + (prop ? "이" : "가")
    } 성공하였습니다.`;

    const callback = Helper.info.bind(Helper, {
      subject: "요청 성공",
      description: description,
    });

    return immediate_action ? callback() : callback;
  },

  // binding this를 피하기 위해 모듈명(Helper) 지정
  defaultErrorHandler: function (data) {
    Helper.info({ error: data.error });
  },

  getToken: function () {
    return $("meta[name=csrf-token]")[0].getAttribute("content");
  },

  getUser: function (user_id) {
    return (
      App.resources.friends.get(user_id) ||
      App.resources.online_users.get(user_id)
    );
  },

  isNumber(number) {
    return number && !isNaN(+number);
  },

  authenticateREST: function (number) {
    if (!this.isNumber(number)) App.router.navigate("#/errors/404");
  },

  isUserChatBanned: function (user_id) {
    return App.resources.chat_bans.isUserChatBanned(user_id);
  },

  isUserFriend: function (user_id) {
    return App.app_view.appearance_view.friends.get(user_id) !== undefined;
  },

  isCurrentUser: function (user_id) {
    return App.current_user.id == user_id;
  },

  callModalError: function () {
    this.info({
      subject: "ERROR",
      description: "입력 전송에 대한 인자가 충분하지 않습니다.",
    });
  },

  alert: function (data) {
    if (!data) return this.callModalError();

    data.subject = data.subject || "경고 창의 제목을 설정해주세요.";
    data.description = data.description || "경고 내용을 입력해주세요.";

    App.app_view.alert_modal_view.render(data);
  },

  input: function (data) {
    if (!data || !data.success_callback) return this.callModalError();

    data.subject = data.subject || "입력받을 창의 제목을 설정해주세요";
    data.description = data.description || "입력받을 내용에 대해 설명해주세요.";

    App.app_view.input_modal_view.render(data);
  },

  info: function (data) {
    if (!data) return this.callModalError();
    if (data.hasOwnProperty("error") && !data.error)
      return App.router.navigate("#/400");

    if (data.error) {
      data.subject = data.error.type;
      data.description = data.error.msg;
    } else {
      data.subject = data.subject || "제목 없음";
      data.description = data.description || "내용이 설정되어 있지 않습니다.";
    }
    App.app_view.info_modal_view.render(data);
  },

  /*
   ** url 의 hash 뒤에 붙는 query 문을 파싱할 때 사용하는 함수
   ** /#/matches?match_type=dual&match_id=10 -> {match_type: "dual", match_id, "10"}
   */
  parseHashQuery: function () {
    let hash = window.location.hash.split("?");
    if (hash.length == 1) {
      hash.page = 1;
      return hash;
    }
    let query = hash[1];
    let result = query.split("&").reduce(function (res, item) {
      let parts = item.split("=");
      res[parts[0]] = parts[1];
      return res;
    }, {});
    if (!result.page) result.page = "1";
    return result;
  },

  getMessageTime: function (timestamp) {
    return (
      timestamp.substr(5, 2) +
      "월 " +
      timestamp.substr(8, 2) +
      "일, " +
      timestamp.substr(11, 5)
    );
  },

  translateRule: function (rule) {
    const rule_name = {
      classic: "기본 규칙",
      accel_wall: "초스피드A",
      accel_paddle: "초스피드B",
      bound_wall: "불규칙 바운드A",
      bound_paddle: "불규칙 바운드B",
      invisible: "투명화",
      dwindle: "스몰볼",
    };

    if (!rule.name) return rule_name[rule];

    rule.name = rule_name[rule.name];
    return rule;
  },
};
