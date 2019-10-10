export default class Application

  constructor: (cvs) ->
    @_canvas = cvs
    cvs.width = 640
    cvs.height = 400
    @_context = cvs.getContext "2d"
    @_events = {}
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

  _draw: ->
    vp = @viewport
    @_context.clearRect 0, 0, @_canvas.width, @_canvas.height

  _tick: (t) =>
    @_draw()
    ts = @_timing
    ts.old = ts.current or t
    ts.current = t
    ts.delta = ts.current - ts.old
    @tick(ts.delta, ts.current)
    if @running
      window.requestAnimationFrame @_tick

  _attachEvents: ->
    @_events.keydown = window.addEventListener "keydown", @_onKeyDown
    @_events.keyup = window.addEventListener "keyup", @_onKeyUp
    if @fillPage
      @_events.resize = window.addEventListener "resize", @_onResize

  _detachEvents: ->
    window.removeEventListener "keydown", @_onKeyDown
    window.removeEventListener "keyup", @_onKeyUp
    if @fillPage
      window.removeEventListener "resize", @_onResize

  _onResize: =>
    [w, h] = [window.innerWidth, window.innerHeight]
    vp = @viewport
    vw = vp.width
    vh = vp.height

    s = (Math.min((w / vw), (h / vh))) | 0
    vp.offX = ((w - vw * s) / 2) | 0
    vp.offY = ((h - vh * s) / 2) | 0
    vp.zoom = s

    @_canvas.width = w
    @_canvas.height = h

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
    @_onResize()
    @running = true
    @_tick()

  stop: ->
    @_detachEvents()
    @running = false

  tick: (delta, current) ->

  sprOn: (o) ->
    f = @_sprites.indexOf o
    if f < 0
      @_sprites.push(o)

  sprOff: (o) ->
    f = @_sprites.indexOf o
    if f >= 0
      @_sprites.splice(f, 1)
