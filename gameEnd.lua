gameEnd = {}

function gameEnd.load()
end

function gameEnd.update(dt)
end

function gameEnd.draw()
    love.graphics.setColor(0,0,0,0.5)

    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    

    love.graphics.setColor(1, 1, 1, 1)
end

return gameEnd