export let UserProfileCardView = Backbone.View.extend({
  template: _.template($("#user-profile-card-template").html()),
  className: "ui segment",

  initialize: function () {},

  render: function () {
    console.log("Render UserProfileCardView");
    this.$el.html(this.template());
    return this;
  },

  close: function () {},
});
