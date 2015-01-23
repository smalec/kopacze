# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.set-sent').click ->
    $('.set-received').removeClass('active')
    $('.set-sent').addClass('active')
    $('.received').hide()
    $('.sent').show()
  $('.set-received').click ->
    $('.set-received').addClass('active')
    $('.set-sent').removeClass('active')
    $('.received').show()
    $('.sent').hide()