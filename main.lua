Menu = require "menu"
Game = require "game"
gameOver = require "gameOver"
paused = require "paused"

gameState = {
    menu = true,  
    play = false,
    gameOver = false,
    paused = false
}

function love.load()
    Menu.load()
    Game.load()
    gameOver.load()
    paused.load()
end

function love.update(dt)
    if gameState.menu then
        Menu.update(dt)
    elseif gameState.play then
        if gameState.paused then
            paused.update(dt)
        else
            Game.update(dt)
        end
    elseif gameState.gameOver then
        gameOver.update(dt)
    end
end

function love.draw()
    if gameState.menu then
        Menu.draw()
    elseif gameState.play then
        Game.draw()
        if gameState.paused then
            paused.draw()
        end
    elseif gameState.gameOver then
        gameOver.draw()
    end

    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 750, 560)
end

function love.keypressed(key)
    if gameState.play then
        Game.keypressed(key)
    end
end