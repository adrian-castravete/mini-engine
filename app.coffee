PIXI.settings.SCALE_MODE = PIXI.SCALE_MODES.NEAREST

export default class Application extends PIXI.Application

  constructor: ->
    super
      width: 320
      height: 288

    @renderer.autoDensity = true

    PIXI.Loader.shared.on 'progress', (loader, resource) ->
      console.log "Loaded #{loader.progress}%: #{resource.name}"

    @_events = {}
    @_sprites = []
    @_timing =
      old: null
      current: null
      delta: null

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

  _tick: (t) =>
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

  _detachEvents: ->
    window.removeEventListener "keydown", @_onKeyDown
    window.removeEventListener "keyup", @_onKeyUp

  _onKeyDown: (evt) =>
    key = evt.key

    if @keyDown
      @keyDown key

  _onKeyUp: (evt) =>
    key = evt.key

    if evt.ctrlKey and key == "F10"
      @running = !@running
      if @running
        console.log "Starting loop..."
        @_tick()
      else
        console.log "Stopping loop..."

    else
      if @keyUp
        @keyUp key

  _loadAssets: (path, dest) ->
    new PIXI.Loader().add(path).load (evt, textures) ->
      if dest
        dest textures

  startGame: ->
    @_attachEvents()
    @running = true
    #@_tick()

  stopGame: ->
    @_detachEvents()
    @running = false

  tick: (delta, current) ->

  loadAndDo: (container, sprite, func) ->
    @_loadAssets sprite.source, (ts) ->
      data = ts[sprite.source]
      func data
      container.addChild sprite

  loadAndAdd: (container, sprite) ->
    @loadAndDo container, sprite, (ts) ->
      sprite.texture = ts.texture
      if sprite.onLoadedTexture
        sprite.onLoadedTexture()
