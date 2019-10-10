import Game from "./game.js"

main = ->
  paper = document.getElementById "paper"
  app = new Game paper
  app.start()

main()
