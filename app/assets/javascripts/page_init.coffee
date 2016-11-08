navbar_init = ->
  $('.button-collapse').sideNav()

select_init = ->
  $('select').material_select()

set_bkgnd = ->
  t = new Trianglify({
    width: $(document).width(),
    height: $(document).height(),
    cell_size: 30,
    variance: 0.6,
    seed: 'mimamamemima',
    x_colors: ["#fff7fb","#ece7f2","#d0d1e6","#a6bddb","#74a9cf","#3690c0","#0570b0","#045a8d","#023858"]
  })
  canvas = t.canvas()
  $('body').before(canvas)

page_ready = ->
  navbar_init()
  select_init()

site_ready = ->
  console.log('site ready')
  set_bkgnd()

$(document).on('turbolinks:load', page_ready)
$(document).ready(site_ready)
$(window).resize(set_bkgnd)
