# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.edit-match').ready ->
  home_foo()
  visitor_foo()

$(document).ready ->
  $('.datepicker').datepicker({
    format: "dd/mm/yyyy",
    language: "pl",
    orientation: "top auto",
    autoclose: true,
    todayHighlight: true
  })

  $('.home-score').change ->
    home_foo()
  $('.home').change ->
    home_foo()

  $('.visitor-score').change ->
    visitor_foo()
  $('.visitor').change ->
    visitor_foo()

home_foo =() ->
  score = $('.home-score').val()
  home = $('.home').val()
  id = $('.match').attr('data-id')
  $.ajax
    url: '/matches/add_scorers'
    type: 'GET'
    data: {score: score, team: home, home: 1, match_id: id}
    dataType: 'html'
    success: (data) ->
      $('.home-scorers').empty()
      $('.home-scorers').append(data)
      $('.selectpicker').selectpicker('refresh')

visitor_foo =() ->
  score = $('.visitor-score').val()
  visitor = $('.visitor').val()
  id = $('.match').attr('data-id')
  $.ajax
    url: '/matches/add_scorers'
    type: 'GET'
    data: {score: score, team: visitor, home: 0, match_id: id}
    dataType: 'html'
    success: (data) ->
      $('.visitor-scorers').empty()
      $('.visitor-scorers').append(data)
      $('.selectpicker').selectpicker('refresh')
