local gameOver = {}
local overlay = { r = 0, g = 0, b = 0, a = 0 }

function gameOver.load()
    flux = require "lib/flux"
        overlay.r = 0
    overlay.g = 0
    overlay.b = 0
    overlay.a = 0

    flux.to(overlay, 0.3, { r = 1, a = 0.4 })
    :after(overlay, 1.5, { r = 0.4, a = 0.85 })
end

function gameOver.update(dt)
    flux.update(dt)
    if love.keyboard.isDown("r") then
    gameState.play = false
    gameState.menu = true
    gameState.gameOver = false
    end
end

function gameOver.draw()
    love.graphics.setColor(overlay.r, overlay.g, overlay.b, overlay.a)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(0.22, 0.84, 0.78)
    love.graphics.printf("GAME OVER!!", 0, 200,love.graphics.getWidth(), "center")
    love.graphics.printf("Final score ".. stats.score,0,250, love.graphics.getWidth(),"center")
    love.graphics.printf("Press R to go back to menu",0,300,love.graphics.getWidth(),"center")
end

return gameOver