# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.set-upcoming').click ->
    $('.set-played').removeClass('active')
    $('.set-received').removeClass('active')
    $('.set-sent').removeClass('active')
    $('.set-upcoming').addClass('active')
    $('.played').hide()
    $('.received').hide()
    $('.sent').hide()
    $('.upcoming').show()
  $('.set-played').click ->
    $('.set-upcoming').removeClass('active')
    $('.set-received').removeClass('active')
    $('.set-sent').removeClass('active')
    $('.set-played').addClass('active')
    $('.upcoming').hide()
    $('.received').hide()
    $('.sent').hide()
    $('.played').show()
  $('.set-received').click ->
    $('.set-played').removeClass('active')
    $('.set-upcoming').removeClass('active')
    $('.set-sent').removeClass('active')
    $('.set-received').addClass('active')
    $('.played').hide()
    $('.upcoming').hide()
    $('.sent').hide()
    $('.received').show()
  $('.set-sent').click ->
    $('.set-upcoming').removeClass('active')
    $('.set-received').removeClass('active')
    $('.set-played').removeClass('active')
    $('.set-sent').addClass('active')
    $('.upcoming').hide()
    $('.received').hide()
    $('.played').hide()
    $('.sent').show()

  $('.datepicker').datepicker({
    format: "dd/mm/yyyy",
    language: "pl",
    orientation: "top auto",
    autoclose: true,
    todayHighlight: true
  })

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

  $('.home-score, .home').change ->
    home_foo()

  $('.visitor-score, .visitor').change ->
    visitor_foo()

  if $('h1').is('.edit-match')
    home_foo()
    visitor_foo()
