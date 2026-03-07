Menu = require "menu"
Game = require "game"
gameOver = require "gameOver"
paused = require "paused"
moonshine = require 'lib/moonshine'

gameState = {
    menu = true,  
    play = false,
    gameOver = false,
    paused = false,
    gameEnd = false
}

function love.load()
    Menu.load()
    Game.load()
    gameOver.load()
    paused.load()
    gameEnd.load()

    effect = moonshine(moonshine.effects.crt)
        .chain(moonshine.effects.scanlines)

effect.crt.distortionFactor = {1.01, 1.01}
effect.crt.scaleFactor = {1,1}
effect.crt.feather = 0.02

effect.scanlines.width = 2
effect.scanlines.opacity = 0.25
    
end

function love.update(dt)
    if gameState.menu then
        Menu.update(dt)
    elseif gameState.play then
        if gameState.paused then
            paused.update(dt)
        elseif gameState.gameEnd then
            gameEnd.update(dt)
        else
            Game.update(dt)
        end
    elseif gameState.gameOver then
        gameOver.update(dt)
    end
end

function love.draw()

    effect(function()

    if gameState.menu then
        Menu.draw()
    elseif gameState.play then
        Game.draw()
        if gameState.paused then
            paused.draw()
        elseif gameState.gameEnd then
            gameEnd.draw()
        end
    elseif gameState.gameOver then
        gameOver.draw()
    end

    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), love.graphics.getWidth() - 80, love.graphics.getHeight() - 25)
    end)
end

function love.keypressed(key)
    if gameState.play then
        Game.keypressed(key)
    end
end