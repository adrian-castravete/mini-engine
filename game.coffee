import Application from "./app.js"

export default class Game extends Application

  constructor: (cvs) ->
    super cvs
    player = new Player this, 64, 48
    @sprOn player

  tick: (dt) ->
