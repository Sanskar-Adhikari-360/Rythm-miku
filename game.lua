local Game = {}
local combo = {}
combo.perfect = 0
combo.good = 0
combo.text = ""


screen = {}
screen.h = love.graphics.getHeight()
screen.w = love.graphics.getWidth()

local Wiggle = require("wiggle")
gameEnd = require("gameEnd")

local game = {}

local lanePositions = {}
local laneWiggles = {}

-- Function for spawning Notes

function Game.spawnNote(x)
    local speed = (hitLine.y + 20) / (secondsPerBeat * 5)
    table.insert(notes, {x = x, y= -20, speed = speed})    
end

-- Function for Customizing falling Notes

function getNotes(fillMode,noteX, noteY, NoteShape, NoteColor) 

    -- assert(type(noteX) ~="number", "[TYPE ERROR] Invalid Note type")
    -- assert(type(noteY) ~="number", "[TYPE ERROR] Invalid Note type")
    -- assert(type(NoteShape) ~="string", "[TYPE ERROR] Invalid Note shape")
    -- assert(type(NoteColor) ~="string", "[TYPE ERROR] Invalid Note color")

    NOTE_SIZE_L, NOTE_SIZE_W= 20, 20
    if NoteShape == "rectangle" then
        return love.graphics.rectangle(fillMode, noteX, noteY, NOTE_SIZE_L, NOTE_SIZE_W)
    end
end

-- Function for Customizing Hit Line

function getHitLine(fillMode,hitLineColor)
    hitLine_W,hitLine_L =love.graphics.getWidth(), 5
    hitLineX,hitLineY = 0,hitLine.y
    return love.graphics.rectangle(fillMode,hitLineX, hitLineY,hitLine_W,hitLine_L)
end

function Game.load()
    love.graphics.setDefaultFilter("nearest","nearest")
    anim8 = require 'lib/anim8'
    
    player = {}
    player.spriteSheet = love.graphics.newImage('sprite/mikuu.png')
    player.grid = anim8.newGrid(38,43, player.spriteSheet:getWidth(),player.spriteSheet:getHeight())

    player.animations= {}
    player.animations.idle = anim8.newAnimation(player.grid('1-6',1), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-8',2), 0.2)
    player.anim = player.animations.idle
    
    song = love.audio.newSource("music/mikumiku.mp3","stream")

    laneWiggles = {}

    for i = 1, 4 do
        laneWiggles[i] = Wiggle.new(100 * i + 10, 0, love.graphics.getHeight(), 40)
    end
end


function Game.start()
    notes = {}
    spawnTimer = 0
    BPM = 120
    secondsPerBeat = 60 / BPM
    hitText = ""
    score = 0 -- for debugging
    spawnedBeats = {}

    stats = {}
    stats.good = 0
    stats.perfect = 0
    stats.miss = 0
    stats.score = score

    hitLine = {}
    hitLine.y = screen.h - 125
    hitLine.radius = 50
    lanePositions = {100, 200, 300, 400}

    player.x = 0 
    player.y = 0
    player.speed = 3
    
    song:seek(0) 
    song:play()
    -- love.audio.setVolume(0.0)
end

function Game.update(dt)
    player.anim:update(dt)
    local songTime = song:tell()
    local beatNumber = math.floor(songTime / secondsPerBeat) + 1

    if not spawnedBeats[beatNumber] then
        local laneIndex = lanePositions[math.random(1, #lanePositions)]
        Game.spawnNote(laneIndex)
        spawnedBeats[beatNumber] = true
    end

    for i = #notes, 1, -1 do
        local note = notes[i]
        note.y = note.y + note.speed * dt

        if note.y > (hitLine.y + hitLine.radius) then
            hitText = "MISS"
            score = score - 1
            combo.perfect = 0
            combo.good = 0
            combo.text = ""
            table.remove(notes,i)

        elseif note.y > love.graphics.getHeight() then
            table.remove(notes, i)
        end
    end

    spawnTimer = spawnTimer + dt

    if score < 0 then
    gameState.menu = false
    gameState.gameOver = true
    gameState.play = false
    song:pause()
    end
for i = 1, #laneWiggles do
    laneWiggles[i]:update(dt)
end

    if #notes == 0 then
        gameState.gameEnd = true
    end
end

function Game.keypressed(key)
    local laneKeys = { "d", "f", "j", "k" }
    if key == "escape" then
    gameState.paused = not gameState.paused
    
    if gameState.paused then
        song:pause()
    else
        song:play()
    end
    
    return
end

if gameState.paused then
    return
end
    for i, laneX in ipairs(lanePositions) do
        if key == laneKeys[i] then
            for j = #notes, 1, -1 do
                local note = notes[j]

                if note.x == laneX then
                    if math.abs(note.y - hitLine.y) <= hitLine.radius then
                        if math.abs(note.y - hitLine.y) <= 25 then
                            hitText = "PERFECT!!"
                            laneWiggles[i]:pluck(35) -- perfect
                            combo.good = 0
                            combo.perfect = combo.perfect + 1
                            if combo.perfect > 1 then
                            combo.text = "Perfect combo: x".. combo.perfect
                            end
                            score = score + 10
                            stats.perfect = stats.perfect + 1
                        elseif math.abs(note.y - hitLine.y) <= 50 then
                            hitText = "GOOD"
                            laneWiggles[i]:pluck(20) -- good    
                            combo.perfect = 0
                            combo.good = combo.good + 1
                            if combo.good > 1 then
                            combo.text = "Good combo: x".. combo.good
                            end
                            score = score + 5
                            stats.good = stats.good + 1
                        end
                        table.remove(notes, j)
                        return
                    end
                end
            end
            combo.perfect = 0
            combo.good = 0
            combo.text = ""
            hitText = "MISS"
            laneWiggles[i]:pluck(10) -- miss :<
            score = score - 3
            stats.miss = stats.miss + 1
        end
    end
end

-- """
-- Args: 
--     noteX: 
--     1. description what is this variable about, TYpe of note X

--     noteY:

-- Return:
--     1. description
--     2. luwa  dfkdkf

-- example:

-- getNotes(2, 3, "rectangle", "crimson horror")
-- """
-- function getNotes(noteX, noteY, NoteShape, NoteColor)
--     assert(type(noteX) ~="number", "[TYPE ERROR] Invalid Note type")
--     assert(type(noteY) ~="number", "[TYPE ERROR] Invalid Note type")
--     assert(type(NoteShape) ~="string", "[TYPE ERROR] Invalid Note shape")
--     assert(type(NoteShape) ~="string", "[TYPE ERROR] Invalid Note color")

--     NOTE_SIZE_L, NOTE_SIZE_W= 20, 20
--     if (NoteShape = "rectangle")
--        return love.graphics.rectangle("fill", noteX, noteY, NOTE_SIZE_L, NOTE_SIZE_W)
--     elseif (NoteShape = "")

    

function Game.draw()
    player.anim:draw(player.spriteSheet, 750, player.y, nil, nil)

    for _, note in pairs(notes) do
        love.graphics.rectangle("fill", note.x, note.y, 20, 20)
        getNotes(note.x,note.y,"rectangle",nil)
    end

    love.graphics.rectangle("fill", 0, hitLine.y, love.graphics.getWidth(), 5)
    
    getHitLine("fill")
    
    for i = 1, #laneWiggles do
        laneWiggles[i]:draw()
    end

    if hitText ~= "" then
        love.graphics.print(hitText, 10, screen.h - 25)
    end       

    if score ~= "" then
        love.graphics.print("Score: "..score, 10, 30)
    end

    if combo ~= "" then
        love.graphics.print(combo.text, 625, 175)
    end

    local mouseX, mouseY = love.mouse.getPosition()
    -- for debugging
    love.graphics.print("Mouse X: "..mouseX.."  Y: "..mouseY, 10, 10)
end

return Game, stats