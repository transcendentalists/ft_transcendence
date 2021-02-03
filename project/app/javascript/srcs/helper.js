export let Helper = {
  fetchContainer: async function (url, hash_args = {}) {
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
};
