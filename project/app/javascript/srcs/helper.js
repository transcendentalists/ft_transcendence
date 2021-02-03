import { App } from "srcs/internal";

export let Helper = {
  fetch: async function (url, hash_args = {}) {
    let params = {
      method: hash_args.hasOwnProperty("method") ? hash_args["method"] : "GET",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.getToken(),
        "Content-Type": "application/json",
      },
    };
    const success_callback = hash_args.hasOwnProperty("success_callback")
      ? hash_args["success_callback"]
      : null;
    const fail_callback = hash_args.hasOwnProperty("fail_callback")
      ? hash_args["fail_callback"]
      : null;
    if (hash_args.hasOwnProperty("headers")) {
      $.extend(params.headers, hash_args.headers);
    }
    if (hash_args.hasOwnProperty("body"))
      params["body"] = JSON.stringify(hash_args["body"]);

    let prefix = hash_args.hasOwnProperty("prefix")
      ? hash_args["prefix"]
      : "api/";

    let response = await fetch(prefix + url, params);
    console.log(response); // for response debugging
    if (response.status == 200 || fail_callback) {
      let data = await response.json();
      if (response.status == 200 && success_callback) success_callback(data);
      else if (response.status == 200) return data;
      else fail_callback(data);
    } else
      return {
        error: {
          type: "Server internal error",
          msg: "잠시 후 다시 시도해주세요.",
        },
      };
  },

  getToken: function () {
    return $("meta[name=csrf-token]")[0].getAttribute("content");
  },

  callModalError: function () {
    this.info({
      subject: "ERROR",
      description: "입력 전송에 대한 인자가 충분하지 않습니다.",
    });
  },

  alert: function (data) {
    if (data == undefined || data == null) return this.callModalError();

    if (!data.hasOwnProperty("subject"))
      data.subject = "경고 창의 제목을 설정해주세요.";
    if (!data.hasOwnProperty("descriotion"))
      data.description = "경고 내용을 입력해주세요.";

    App.appView.alert_modal_view.render(data);
  },

  input: function (data) {
    if (
      data == undefined ||
      data == null ||
      !data.hasOwnProperty("success_callback")
    )
      return this.callModalError();

    if (!data.hasOwnProperty("subject"))
      data.subject = "입력받을 창의 제목을 설정해주세요";
    if (!data.hasOwnProperty("description"))
      data.description = "입력받을 내용에 대해 설명해주세요.";

    App.appView.input_modal_view.render(data);
  },

  info: function (data) {
    if (data == undefined || data == null) return this.callModalError();

    if (!data.hasOwnProperty("subject"))
      data.subject = "알려줄 내용의 제목을 설정해주세요";
    if (!data.hasOwnProperty("description"))
      data.description = "알려줄 내용을 설명해주세요.";

    App.appView.info_modal_view.render(data);
  },
};
