paused = {}

function paused.load()

end

function paused.update(dt)
    -- if love.keyboard.isDown("escape") then
    --     gameState.paused = false
    -- end
end

function paused.draw()
    love.graphics.print("Your game is paused", 200, 200)
end

return paused