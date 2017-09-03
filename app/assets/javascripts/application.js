//= require env
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap
//= require_tree .
//= require_self

$(() => {
  $('.filter input[type=radio], .filter input[type=checkbox], .filter select').change(()  => {
    $(this).closest('form').submit()
  });

  $('.comments a').click( () => {
    $('.comments').hide()
  });

  $('[data-toggle="popover"]').popover();
})
