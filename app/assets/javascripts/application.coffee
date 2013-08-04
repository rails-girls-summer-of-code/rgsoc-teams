#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require_tree .
#= require_self

$ ->
  $('.filter input[type=radio]').click ->
    $(this).closest('form').submit()
  $('.filter select').change ->
    $(this).closest('form').submit()
  $('.comments a').click ->
    $('.comments').hide()
