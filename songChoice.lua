local songChoice = {}
local screen = {
    w = love.graphics.getWidth(),
    h = love.graphics.getHeight()   
}

local box = {
    width = screen.w * 0.6,
    height = screen.h * 0.6,    -- main container for song choice
}
box.x = screen.w / 2 - (box.width/2)
box.y = screen.h / 2 - (box.height/2)  -- the position of the main container

local album = {
    x = box.x + 50,
    y = box.y + 150,
    height = (screen.h * 0.25), -- container for album art
    width = (screen.w * 0.20)
}

function songChoice.load()


end

function songChoice.update(dt)  

end

function songChoice.draw()
    love.graphics.setColor(0, 0.8, 0.8) 
    -- love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
    love.graphics.rectangle("line", box.x, box.y, box.width, box.height) 
    love.graphics.rectangle("fill", album.x, album.y, album.width, album.height)
    love.graphics.setColor(0, 0, 0, 1)
end

return songChoice