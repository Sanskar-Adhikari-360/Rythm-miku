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
box.y = screen.h / 2 - (box.height/2)  

local album = { -- the position of the album art
    height = (screen.h * 0.20), -- container for album art
    width = (screen.w * 0.15)
}
album.x = box.x + 50    -- the position of the main container
album.y = box.y + (box.height / 2) - (album.height / 2)

local details = {
    x = album.x + album.width + 50,
    y = album.y,
    height = album.height,
    width = box.width - (album.width + 150), -- container for song details
    name = "Sienna",
    artist = "The marias",
    duration = "3:44",
    difficulty = "Medium"
}


function songChoice.load()
        AlbumArt = love.graphics.newImage("image.png")
        AlbumArtHeight = AlbumArt:getHeight()
        AlbumArtWidth = AlbumArt:getWidth()
        print(album.height, album.width)

end

function songChoice.update(dt)  

end

function songChoice.draw()
    love.graphics.setColor(0, 0.8, 0.8) 
    -- love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
    love.graphics.rectangle("line", box.x, box.y, box.width, box.height) 
    -- love.graphics.rectangle("fill", album.x, album.y, album.width, album.height)
    love.graphics.draw(AlbumArt,album.x,album.y,0, album.width / AlbumArtWidth, album.height / AlbumArtHeight )
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Name: "..details.name, details.x, details.y + 15)
    love.graphics.print("Artist: "..details.artist, details.x, details.y + 40)
    love.graphics.print("Duration: "..details.duration, details.x, details.y + 65)
    love.graphics.print("Difficulty: "..details.difficulty, details.x, details.y + 90)

    love.graphics.setColor(0, 0, 0, 1)
end

return songChoice