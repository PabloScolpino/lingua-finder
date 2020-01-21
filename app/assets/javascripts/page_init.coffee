navbar_init = ->
  $('.sidenav').sidenav()

select_init = ->
  $('select').formSelect()

set_bkgnd = ->
  t = new Trianglify({
    width: $(document).width(),
    height: $(document).height(),
    cell_size: 50,
    variance: 1.6,
    seed: 'mimamamemima',
    x_colors: ["#eff3ff","#c6dbef","#9ecae1","#6baed6","#4292c6" ]
  })

  background = document.getElementById('background')
  if background
    canvas = t.canvas(background)
  else
    canvas = t.canvas()
    canvas.setAttribute('id','background')

  $('body').before(canvas)

page_ready = ->
  navbar_init()
  select_init()

site_ready = ->
  # console.log('site ready')
  set_bkgnd()

$(document).on('turbolinks:load', page_ready)
$(document).ready(site_ready)
$(window).resize(set_bkgnd)
