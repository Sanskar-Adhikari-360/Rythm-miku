  notes = {}
  spawnTimer = 0
  BPM = 120
  secondsPerBeat = 60 / BPM

    hitText = ""
    score = 0

  hitLine = {}
  hitLine.y = 500
  hitLine.radius = 50

  lanes = {100, 200, 300, 400}

  function spawnNote(x)
    local speed = (hitLine.y + 20) / secondsPerBeat
    table.insert(notes,{x = x, y= -20, speed = 200})    
  end


function love.load()
    anim8 = require 'lib/anim8'
    love.graphics.setDefaultFilter("nearest","nearest")

    player = {}
    player.x = 0 
    player.y = 0
    player.speed = 3
    player.spriteSheet = love.graphics.newImage('sprite/mikuu.png')
    player.grid = anim8.newGrid(38,43, player.spriteSheet:getWidth(),player.spriteSheet:getHeight())

    player.animations= {}
    player.animations.idle = anim8.newAnimation(player.grid('1-6',1), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-8',2), 0.2)

    player.anim = player.animations.idle

    
    song = love.audio.newSource("music/mikumiku.mp3","stream")
    love.audio.play(song)
end

function love.update(dt)
    -- if love.keyboard.isDown("d") then
    -- player.x = player.x + player.speed    
    -- end
    -- if love.keyboard.isDown("a") then
    -- player.x = player.x - player.speed
    -- end
    -- if love.keyboard.isDown("w") then
    -- player.y = player.y - player.speed
    -- end
    -- if love.keyboard.isDown("s") then
    -- player.y = player.y + player.speed
    -- end

    player.anim:update(dt)

    local songTime = song:tell()
    local beatNumber = math.floor(songTime / secondsPerBeat) + 1

    if not spawnedBeats then spawnedBeats = {} end
    if not spawnedBeats[beatNumber] then
         local laneIndex = lanes[math.random(1, #lanes)]
        spawnNote(laneIndex)
        spawnedBeats[beatNumber] = true
    end

    for i = #notes, 1, -1 do
    local note = notes[i]
    note.y = note.y + note.speed * dt

    if note.y > love.graphics.getHeight() then
        table.remove(notes, i)
    end

    end

    spawnTimer = spawnTimer + dt


function love.keypressed(key)
    local laneKeys = { "d", "f", "j", "k" }

    for i, laneX in ipairs(lanes) do
        if key == laneKeys[i] then
            
            for j = #notes, 1, -1 do
                local note = notes[j]

                if note.x == laneX then
                    if math.abs(note.y - hitLine.y) <= hitLine.radius then
                        if math.abs(note.y - hitLine.y) <= 25 then
                            hitText = "PERFECT!!"
                            score = score + 10
                        elseif math.abs(note.y - hitLine.y) <= 50 then
                            hitText = "GOOD"
                            score = score + 5
                        end
                        table.remove(notes, j)
                        return
                    end
                end
            end

            hitText = "MISS"
            score = score - 3
        end
    end
end

end   


function love.draw()
   player.anim:draw(player.spriteSheet, 750, player.y, nil, nil)

       for _, note in pairs(notes) do
        love.graphics.rectangle("fill",note.x,note.y,20,20)
    end

    love.graphics.rectangle("fill", 0, hitLine.y, love.graphics.getWidth(), 5)

if hitText ~= "" then
    love.graphics.print(hitText, 10, 575)
end       

if score ~= "" then
    love.graphics.print("Score: "..score)
end



local mouseX, mouseY = love.mouse.getPosition()

    -- for debguing
    love.graphics.print("Mouse X: "..mouseX.."  Y: "..mouseY, 10, 10)
    
end