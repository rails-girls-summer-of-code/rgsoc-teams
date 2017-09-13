//= require env
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap
//= require_tree .
//= require_self

$(function() {
  $('.filter input[type=radio], .filter input[type=checkbox], .filter select').change(function() {
    $(this).closest('form').submit();
  });

  $('.comments a').click(function() {
    $('.comments').hide();
  });

  $('[data-toggle="popover"]').popover();
});
