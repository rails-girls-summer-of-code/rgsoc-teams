#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require_tree .
#= require_self

$ ->
  $('.filter input[type=radio], .filter input[type=checkbox], .filter select').click ->
    $(this).closest('form').submit()
  $('.comments a').click ->
    $('.comments').hide()
