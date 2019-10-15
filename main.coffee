import Game from "./game.js"

#bump

main = ->
  app = new Game()
  document.body.appendChild app.view
  app.resizeTo = window
  app.startGame()

main()
