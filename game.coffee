import Application from "./app.js"


class Player

  constructor: (game, x, y) ->
    @x = x
    @y = y
    @w = 16
    @h = 32
    @sx = 48
    @sy = 32
    @spr = 'player'
    @si = 0

    @game = game
    @game.loadImage 'player', "assets/images/player.png"
    @game.sprOn this

  tick: ->
    @si += 1
    @sx = 16 * (@si % 4)


export default class Game extends Application

  constructor: (cvs) ->
    super cvs
    @ellapsedTime = 0
    @lastTick = 0
    @player = new Player this, 64, 48

  tick: (dt) ->
    @ellapsedTime += dt | 0
    lt = @lastTick
    eti = (@ellapsedTime / 1000) | 0
    if eti > lt
      for i in [lt...eti]
        @player.tick()
      @lastTick = eti
