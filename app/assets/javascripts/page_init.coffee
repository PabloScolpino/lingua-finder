navbar_init = ->
  $('.sidenav').sidenav()

select_init = ->
  $('select').formSelect()

page_ready = ->
  navbar_init()
  select_init()

$(document).on('turbolinks:load', page_ready)
