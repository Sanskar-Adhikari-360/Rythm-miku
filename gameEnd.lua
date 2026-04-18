gameEnd = {}

function gameEnd.load()
    local Game = require "game"
end

function gameEnd.update(dt)
    if not gameState.gameEnd then return end

    if love.keyboard.isDown("return") then
        switchState("menu", "down")
        Stats = { good = 0, perfect = 0, miss = 0, score = 0 }
    end
end

function gameEnd.draw()
    love.graphics.setColor(0,0,0,0.5)

    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1, 1)
    
local centerY = love.graphics.getHeight() / 2
local gap = 30 
love.graphics.printf("Song Finished!!", 0, centerY - gap*2, love.graphics.getWidth(), "center")
love.graphics.printf("Final score: "..Stats.score, 0, centerY - gap, love.graphics.getWidth(), "center")
love.graphics.printf("Perfect Hit: x"..Stats.perfect, 0, centerY, love.graphics.getWidth(), "center")
love.graphics.printf("Good Hit: x"..Stats.good, 0, centerY + gap, love.graphics.getWidth(), "center")
love.graphics.printf("Missed Hit: x"..Stats.miss, 0, centerY + gap*2, love.graphics.getWidth(), "center")
love.graphics.printf("Press Enter to return to menu", 0, centerY + gap*4, love.graphics.getWidth(), "center")       
end

return gameEnd