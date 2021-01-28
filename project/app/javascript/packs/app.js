export let app = 4;

console.log("webpack success");

$(document).ready(function () {
  var $div = $("<div id='jquery-test'></div>");
  $div.appendTo("body");
  var $img = $("<img src='/assets/rails.png'></img>");
  $("#jquery-test").html($img);
  let ans = _.max([5, 2, 1]);
  if (ans == 5) console.log("underscore success");

  const Cat = Backbone.Model.extend({
    defaults: {
      a: 1,
      b: 2,
      c: 3,
    },

    initialize: function (msg) {
      console.log(msg);
    },
  });

  let cat = new Cat("backbone success");
  $(".ui.modal").modal("show");
});
