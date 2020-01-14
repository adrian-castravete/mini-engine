import Game from "./game.js"

# Let's make a new version

main = ->
  app = new Game()
  document.body.appendChild app.view
  app.resizeTo = window
  app.startGame()

main()
