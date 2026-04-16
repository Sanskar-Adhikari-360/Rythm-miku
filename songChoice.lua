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
}

local arrowSize = 30
local leftArrow = {
    x = box.x + 10,
    y = box.y + (box.height / 2) - (arrowSize / 2),
    w = arrowSize,
    h = arrowSize,
}
local rightArrow = {
    x = box.x + box.width - 10 - arrowSize,
    y = box.y + (box.height / 2) - (arrowSize / 2),
    w = arrowSize,
    h = arrowSize,
}
local index = 1
local songs = {
    {
        name = "Sienna",
        artist = "The marias",
        duration = "3:44",
        difficulty = "Medium",
        BPM = 120,
        image = "assets/Sumbarine.png"
    },
    {
        name = "From the start",
        artist = "Laufey",
        duration = "3:44",
        difficulty = "Medium",
        BPM = 120,
        image = "assets/Bewitched.png"

    },
    {
        name = "Pain",
        artist = "Pink Panthress",
        duration = "3:44",
        difficulty = "Easy",
        BPM = 120,
        image = "assets/To hell with it.png"
    }
}

function songChoice.load()
        print(album.height, album.width)
        loadSong(index)

end

    function loadSong(index)
        AlbumArt = love.graphics.newImage(songs[index].image)
        AlbumArtHeight = AlbumArt:getHeight()
        AlbumArtWidth  = AlbumArt:getWidth()
        details.name = songs[index].name
        details.artist = songs[index].artist
        details.duration =  songs[index].duration
        details.difficulty = songs[index].difficulty
    end

    function songChoice.mousepressed(mx, my, button)
        if button == 1 then
            if mx >= leftArrow.x and mx <= leftArrow.x + leftArrow.w
            and my >= leftArrow.y and my <= leftArrow.y + leftArrow.h then
                index = ((index - 1 - 1) % #songs) + 1 
                loadSong(index)
            end
        if mx >= rightArrow.x  and mx <= rightArrow.x  + rightArrow.w
        and my >= rightArrow.y and my <= rightArrow.y  + rightArrow.h then
                index = ((index + 1 + 1) % #songs ) + 1
                loadSong(index)
        end
        end
        
    end
function songChoice.update(dt)  



end

function songChoice.draw()
    love.graphics.setColor(0, 0.8, 0.8) 
    love.graphics.rectangle("line", box.x, box.y, box.width, box.height) 
    love.graphics.draw(AlbumArt,album.x,album.y,0, album.width / AlbumArtWidth, album.height / AlbumArtHeight )
    love.graphics.setColor(1, 1, 1, 1)
    
    love.graphics.print("Name: "..details.name, details.x, details.y + 15)
    love.graphics.print("Artist: "..details.artist, details.x, details.y + 40)
    love.graphics.print("Duration: "..details.duration, details.x, details.y + 65)
    love.graphics.print("Difficulty: "..details.difficulty, details.x, details.y + 90)

    love.graphics.setColor(0, 0.8, 0.8)
    love.graphics.polygon("fill",
        leftArrow.x + leftArrow.w, leftArrow.y,
        leftArrow.x,               leftArrow.y + leftArrow.h / 2,
        leftArrow.x + leftArrow.w, leftArrow.y + leftArrow.h)

    -- Right arrow
    love.graphics.polygon("fill",
        rightArrow.x,               rightArrow.y,
        rightArrow.x + rightArrow.w, rightArrow.y + rightArrow.h / 2,
        rightArrow.x,               rightArrow.y + rightArrow.h)

    love.graphics.setColor(0, 0, 0, 1)
end

return songChoice