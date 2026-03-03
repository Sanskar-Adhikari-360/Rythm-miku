Menu = require "menu"
Game = require "game"
gameOver = require "gameOver"

gameState = {
    menu = false,  
    play = false,
    gameOver = true
}

function love.load()
    Menu.load()
    Game.load()
    gameOver.load()
end

function love.update(dt)
    if gameState.menu then
        Menu.update(dt)
    elseif gameState.play then
        Game.update(dt)
    elseif gameState.gameOver then
        gameOver.update(dt)
    end
end

function love.draw()
    if gameState.menu then
        Menu.draw()
    elseif gameState.play then
        Game.draw()
    elseif gameState.gameOver then
        gameOver.draw()
    end
end

function love.keypressed(key)
    if gameState.play then
        Game.keypressed(key)
    end
end