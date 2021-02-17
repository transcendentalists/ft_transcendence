import { App } from "srcs/internal";

export let ChatRoomMemberUnitView = Backbone.View.extend({
  className: "ui teal image label user-unit",
  template: _.template($("#chat-room-member-unit-view-template").html()),
  tagName: "a",

  initialize: function (options) {
    this.parent = options.parent;
    this.position_icons = {
      owner: "king",
      admin: "rook",
      member: "pawn",
    };
    this.listenTo(this.model, "remove", this.close);
    this.listenTo(this.model, "change:mute", this.changeMute);
    this.listenTo(this.model, "change:position", this.changePosition);
  },

  render: function () {
    this.$el.html(this.template(this.model.attributes));
    this.$el.attr("data-user-id", this.model.id);
    if (!this.model.get("mute"))
      this.$el.find(".mute.icon").css("display", "none");

    return this;
  },

  changeMute: function () {
    if (this.model.get("mute"))
      this.$el.find(".mute.icon").css("display", "inline");
    else this.$el.find(".mute.icon").css("display", "none");
  },

  changePosition: function () {
    const position = this.model.get("position");
    const remove_icon = this.position_icons[
      position == "member" ? "admin" : "member"
    ];
    const add_icon = this.position_icons[position];

    this.$el.find(".position.icon").removeClass(remove_icon);
    this.$el.find(".position.icon").addClass(add_icon);
  },

  close: function () {
    this.remove();
  },
});
