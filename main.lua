Menu = require "menu"
Game = require "game"

gameState = {
    menu = true,  
    play = false,
    gameOver = false
}

function love.load()
    Menu.load()
    Game.load() 
end

function love.update(dt)
    if gameState.menu then
        Menu.update(dt)
    elseif gameState.play then
        Game.update(dt)
    end
end

function love.draw()
    if gameState.menu then
        Menu.draw()
    elseif gameState.play then
        Game.draw()
    end
end

function love.keypressed(key)
    if gameState.play then
        Game.keypressed(key)
    end
end