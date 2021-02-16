import { App } from "srcs/internal";

export let ChatRoomMemberUnitView = Backbone.View.extend({
  className: "ui teal image label user-unit",
  template: _.template($("#chat-room-member-unit-view-template").html()),
  events: {},

  initialize: function (member) {
    this.model = member;
    // this.listenTo(this.model, "remove", this.close);
    // this.listenTo(this.model, "change:mute", this.changeMute);
  },

  render: function () {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

  // changeMute: function () {
  //   this.$el.find(".circular").attr("data-status", this.model.get("status"));
  // },

  close: function () {
    this.remove();
  },
});
