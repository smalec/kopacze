# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.datepicker').datepicker({
    format: "dd/mm/yyyy",
    language: "pl",
    orientation: "top auto",
    autoclose: true,
    todayHighlight: true
  })

  $('.invite').click ->
    $('.invite').hide()
    $('.invitation-form').show()
