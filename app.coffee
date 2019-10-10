export default class Application extends PIXI.Application

  constructor: ->
    super
      width: 320
      height: 288

    @renderer.autoDensity = true

    @_events = {}
    @_images = {}
    @_sprites = []
    @_timing =
      old: null
      current: null
      delta: null

    @fillPage = true
    @running = false

    @camera =
      x: 0
      y: 0

    @viewport =
      width: 160
      height: 144
      offX: 0
      offY: 0
      zoom: 2

  _drawSprite: (o) ->
    z = @viewport.zoom
    img = @_images[o.spr]

    w = o.w or 16
    h = o.h or 16
    ox = -w/2
    oy = -h/2

    g = @_context
    g.save()
    g.scale z, z
    g.translate o.x, o.y
    if o.sx isnt null and o.sy isnt null
      g.drawImage img, o.sx, o.sy, w, h, ox, oy, w, h
    else
      g.drawImage img, ox, oy
    g.restore()

  _draw: ->
    vp = @viewport
    g = @_context
    g.imageSmoothingEnabled = false
    g.clearRect 0, 0, @_canvas.width, @_canvas.height
    g.fillStyle = '#55aaff'
    g.fillRect vp.offX, vp.offY, vp.width * vp.zoom, vp.height * vp.zoom
    g.save()
    g.translate vp.offX, vp.offY
    for o, i in @_sprites
      @_drawSprite o
    g.restore()

  _tick: (t) =>
    ts = @_timing
    ts.old = ts.current or t
    ts.current = t
    ts.delta = ts.current - ts.old
    @tick(ts.delta, ts.current)

    @_draw()

    if @running
      window.requestAnimationFrame @_tick

  _attachEvents: ->
    @_events.keydown = window.addEventListener "keydown", @_onKeyDown
    @_events.keyup = window.addEventListener "keyup", @_onKeyUp

  _detachEvents: ->
    window.removeEventListener "keydown", @_onKeyDown
    window.removeEventListener "keyup", @_onKeyUp

  _onKeyDown: (evt) =>
    key = evt.key

  _onKeyUp: (evt) =>
    key = evt.key

    if evt.ctrlKey and key == "F10"
      @running = !@running
      if @running
        console.log "Starting loop..."
        @_tick()
      else
        console.log "Stopping loop..."

  start: ->
    @_attachEvents()
    @running = true
    @_tick()

  stop: ->
    @_detachEvents()
    @running = false

  tick: (delta, current) ->

  loadImage: (name, path) ->
    img = new window.Image()
    img.src = path
    @_images[name] = img

  sprOn: (o) ->
    f = @_sprites.indexOf o
    if f < 0
      @_sprites.push(o)

  sprOff: (o) ->
    f = @_sprites.indexOf o
    if f >= 0
      @_sprites.splice(f, 1)
