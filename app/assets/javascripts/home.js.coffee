# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  if $('.cat').val() == '2'
    $('.player').show()
  $('.cat').change ->
    category = $('.cat').val()
    if category == '2'
      $('.player').show()
    else
      $('.player').hide()