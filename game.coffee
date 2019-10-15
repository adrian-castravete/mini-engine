import Application from "./app.js"


class Player extends PIXI.Sprite

  constructor: (game, x, y) ->
    super()

    @x = x
    @y = y
    #@width = 16
    #@height = 32
    @pivot.set 8, 16
    @sx = 48
    @sy = 32
    @si = 0

    @source = "assets/images/player.png"

  tick: ->
    @si += 1
    @sx = 16 * (@si % 4)

  onLoadedTexture: ->
    @buildFrames()
    @texture.frame = @frames.still

  buildFrames: ->
    @frames =
      still: new PIXI.Rectangle 16, 0, 16, 32


class TiledLevel extends PIXI.Container

  constructor: (app, stage, fileName) ->
    super()

    @source = fileName
    vp = app.viewport

    @scale = new PIXI.Point vp.zoom, vp.zoom
    app.loadAndDo stage, this, (data) ->
      console.log "Reached level load"


export default class Game extends Application

  constructor: ->
    super()

    @ellapsedTime = 0
    @lastTick = 0

    stage = @stage
    level = new TiledLevel this, stage, "assets/levels/test.json"

    @player = new Player this, 64, 48
    @level = level

    @loadAndAdd level, @player

  keyDown: (key) =>

  keyUp: (key) =>

  tick: (dt) ->
    @ellapsedTime += dt | 0
    lt = @lastTick
    eti = (@ellapsedTime / 1000) | 0
    if eti > lt
      for i in [lt...eti]
        @player.tick()
      @lastTick = eti
