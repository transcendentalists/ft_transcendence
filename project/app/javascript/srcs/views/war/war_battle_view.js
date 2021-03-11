export let WarBattleView = Backbone.View.extend({
  template: _.template($("#war-battle-view-template").html()),

  initialize: function () {},

  countDown: function () {
    this.$(".remain-time").empty();

    let $remain_time = this.$(".remain-time");
    $remain_time.html("5min");

    let time = 299;
    let min = "";
    let sec = "";
    
    let count = setInterval(
      function () {
        min = parseInt(time / 60);
        sec = time % 60;
        --time;
        $remain_time.html(min + "min " + sec + "sec")
        if (time < 0) {
          clearInterval(count);
          count = null;
          $remain_time.empty();
          // this.start();
        }
      }.bind(this),
      1000
    );
  },

  render: function () {
    this.$el.html(this.template());
    this.countDown();
    return this;
  },

  close: function () {
    this.remove();
  },
});
