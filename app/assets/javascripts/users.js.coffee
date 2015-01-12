$(document).ready ->
  $('.submittable').click ->
    $(this).parents('form:first').submit()