Menu = require "menu"
Game = require "game"
gameOver = require "gameOver"
paused = require "paused"
songChoice = require "songChoice"
moonshine = require 'lib/moonshine'
trans = require 'transition'

local mainFont = love.graphics.newFont('fonts/toxigenesis.otf')
love.graphics.setFont(mainFont)

gameState = {
    menu = true,  
    play = false,
    songChoice = false,
    gameOver = false,
    paused = false,
    gameEnd = false
}

function switchState(newState,dir)
if dir == "down" then
        trans.start(1, "linear","down", function ()
        for i in pairs(gameState) 
        do gameState[i] = false 
        end
        gameState[newState] = true
    end)
end
if dir == "right" then
    trans.start(1, "linear","right", function ()
        for i in pairs(gameState) 
        do gameState[i] = false 
        end
        gameState[newState] = true
    end)
end
end

function love.load()
    Menu.load()
    Game.load()
    gameOver.load()
    paused.load()
    gameEnd.load()
    songChoice.load()

effect = moonshine(moonshine.effects.scanlines)

effect.scanlines.width = 2
effect.scanlines.opacity = 0.25
    
end

function love.update(dt)
    trans.update(dt)
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
    elseif gameState.songChoice then
            songChoice.update(dt)
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
    elseif gameState.songChoice then
            songChoice.draw()
    end

    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), love.graphics.getWidth() - 70, love.graphics.getHeight() - 25)
    end)
    trans.draw()
end

function love.keypressed(key)
    if love.keyboard.isDown("q") then
    love.event.quit(0)
    end

    if gameState.play then
        Game.keypressed(key)
    end
end

function love.mousepressed(x, y, button)
    if gameState.songChoice then
    songChoice.mousepressed(x, y, button)
    end
end
