import { App, Helper } from "srcs/internal";

export let SignInView = Backbone.View.extend({
  id: "sign-in-view",
  template: _.template($("#sign-in-view-template").html()),
  warning_message_template: _.template($("#warning-message-template").html()),
  events: {
    "click .button": "login",
  },

  initialize: function () {},

  signInParams: function (name, password) {
    return {
      method: "POST",
      success_callback: this.successCallback.bind(this),
      fail_callback: this.failCallback.bind(this),
      body: {
        user: {
          name,
          password,
        },
      },
    };
  },

  successCallback: function (data) {
    // top.location =
    //   "https://github.com/login/oauth/authorize?client_id=Iv1.51c3995ab7bfaf31";
    window.open(
      "https://github.com/login/oauth/authorize?client_id=Iv1.51c3995ab7bfaf31",
      "_blanck",
      "width=600, height=400"
    );
    // fetch(
    //   "https://github.com/login/oauth/authorize?client_id=Iv1.51c3995ab7bfaf31",
    //   {
    //     headers: {
    //       Origin: "http://localhost:3000",
    //       // "Sec-Fetch-Mode": "no-cors",
    //     },
    //     method: "GET",
    //     mode: "cors",
    //   }
    // ).then((response) => console.log(response));
    App.me.set({ signed_in: true, id: data["me"]["id"] });
    App.me.fetch();
    console.log(data);
  },

  failCallback: function (data) {
    this.$(".ui.negative.message").empty();
    this.$(".ui.negative.message").append(
      this.warning_message_template(data.error)
    );
    this.$(".ui.negative.message").show();
  },

  login: function () {
    let name = $("input[name=name]").val();
    let password = $("input[name=password]").val();
    Helper.fetchContainer(
      `users/${name}/session`,
      this.signInParams(name, password)
    );
  },

  render: function () {
    this.$el.empty();
    this.$el.html(this.template());
    this.$(".ui.negative.message").hide();
    return this;
  },

  close: function () {
    this.remove();
  },
});
