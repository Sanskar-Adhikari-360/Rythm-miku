paused = {}

function paused.load()
    
end

function paused.update(dt)
    
end

function paused.draw()
    love.graphics.setColor(0,0,0,0.5)

    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    

    love.graphics.setColor(1, 1, 1, 1)
end

return paused