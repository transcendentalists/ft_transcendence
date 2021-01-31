export let UserIndexView = Backbone.View.extend({
  // template: _.template($("#user-index-view-template").html()),

  render: function () {},

  close: function () {
    // listenTo는 view 삭제시 삭제되므로 누수 방지를 위해 on으로 설정한 event만 off 처리
    this.remove();
  },
});
