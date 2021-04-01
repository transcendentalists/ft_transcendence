export let ChatRoomMemberUnitView = Backbone.View.extend({
  className: "chat-member-unit",
  template: _.template($("#chat-room-member-unit-view-template").html()),
  tagName: "div",

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
    if (position == "ghost") this.close();

    const remove_icons = [...Object.keys(this.position_icons)]
      .filter((key) => key !== position)
      .map((key) => this.position_icons[key]);
    remove_icons.forEach((icon) =>
      this.$el.find(".position.icon").removeClass(icon)
    );

    const add_icon = this.position_icons[position];
    this.$el.find(".position.icon").addClass(add_icon);
  },

  close: function () {
    this.remove();
  },
});
