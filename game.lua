local Game = {}

local combo = { perfect = 0, good = 0, text = "" }

local screen = { w = 0, h = 0 }

local wiggle = require("wiggle")
local game_end = require("gameEnd")

local anim8 = nil

local player = {}
local song = nil

local notes = {}
local lane_positions = {}
local lane_wiggles = {}

local hit_line = {}

Stats = { good = 0, perfect = 0, miss = 0, score = 0 }
local score = 0
local hit_text = ""

local spawn_timer = 0
local seconds_per_beat = 0
local spawned_beats = {}

local NOTE_SIZE = 20

local function spawn_note(x)
    local travel_time = seconds_per_beat * 5
    local speed = (hit_line.y + 20) / travel_time
    table.insert(notes, { x = x, y = -20, speed = speed })
end

local function draw_note(fill_mode, note_x, note_y, note_shape)
    if note_shape == "rectangle" then
        love.graphics.rectangle(
            fill_mode,
            note_x - NOTE_SIZE / 2,
            note_y,
            NOTE_SIZE,
            NOTE_SIZE
        )
    end
end

-- draw hit line
local function draw_hit_line(fill_mode)
    local hit_line_w, hit_line_h = love.graphics.getWidth(), 5
    local hit_line_x, hit_line_y = 0, hit_line.y
    love.graphics.rectangle(fill_mode, hit_line_x, hit_line_y, hit_line_w, hit_line_h)
end

function Game.load()
    screen.w = love.graphics.getWidth()
    screen.h = love.graphics.getHeight()

    anim8 = require 'lib/anim8'

    player.sprite_sheet = love.graphics.newImage('sprite/mikuu.png')
    player.grid = anim8.newGrid(38, 43, player.sprite_sheet:getWidth(), player.sprite_sheet:getHeight())

    player.animations = {}
    player.animations.idle = anim8.newAnimation(player.grid('1-6', 1), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-8', 2), 0.2)
    player.anim = player.animations.idle

    song = love.audio.newSource("music/mikumiku.mp3", "stream")
end

function Game.create_lane_wiggles()
    lane_wiggles = {}
    for i, lane_x in ipairs(lane_positions) do
        lane_wiggles[i] = wiggle.new(lane_x, 0, love.graphics.getHeight(), 40)
    end
end

function Game.start()
    notes = {}
    spawn_timer = 0
    local bpm = 120
    seconds_per_beat = 60 / bpm
    hit_text = ""
    score = 0
    spawned_beats = {}

    Stats = { good = 0, perfect = 0, miss = 0, score = score }

    hit_line = { y = screen.h - 125, radius = 50 }
    lane_positions = { 150, 300, 450, 600 }

    player.x = 0
    player.y = 0
    player.speed = 3

    if song then
        song:seek(0)
        song:play()
        love.audio.setVolume(0.0)
    end

    Game.create_lane_wiggles()
end

function Game.update(dt)
    if player.anim then player.anim:update(dt) end

    local song_time = 0
    if song then song_time = song:tell() end
    local beat_number = math.floor(song_time / seconds_per_beat) + 1

    if not spawned_beats[beat_number] then
        local lane_x = lane_positions[math.random(1, #lane_positions)]
        spawn_note(lane_x)
        spawned_beats[beat_number] = true
    end

    for i = #notes, 1, -1 do
        local note = notes[i]
        note.y = note.y + note.speed * dt

        if note.y > (hit_line.y + hit_line.radius) then
            hit_text = "MISS"
            score = score - 1
            combo.perfect = 0
            combo.good = 0
            combo.text = ""
            table.remove(notes, i)
            Stats.miss = Stats.miss + 1

        elseif note.y > love.graphics.getHeight() then
            table.remove(notes, i)
        end
    end

    spawn_timer = spawn_timer + dt

    if score < 0 then
        if gameState then
            gameState.menu = false
            gameState.gameOver = true
            gameState.play = false
        end
        if song then song:pause() end
    end

    for i = 1, #lane_wiggles do
        lane_wiggles[i]:update(dt)
    end

    if #notes == 0 then
        if gameState then gameState.gameEnd = true end
    end
end

function Game.keypressed(key)
    local lane_keys = { "d", "f", "j", "k" }

    if key == "escape" then
        if gameState then gameState.paused = not gameState.paused end

        if gameState and gameState.paused then
            if song then song:pause() end
        else
            if song then song:play() end
        end
        return
    end

    if gameState and gameState.paused then return end

    for i, lane_x in ipairs(lane_positions) do
        if key == lane_keys[i] then
            for j = #notes, 1, -1 do
                local note = notes[j]
                if note.x == lane_x then
                    if math.abs(note.y - hit_line.y) <= hit_line.radius then
                        local dist = math.abs(note.y - hit_line.y)
                        if dist <= 25 then
                            hit_text = "PERFECT!!"
                            if lane_wiggles[i] then lane_wiggles[i]:pluck(35) end
                            combo.good = 0
                            combo.perfect = combo.perfect + 1
                            if combo.perfect > 1 then
                                combo.text = "Perfect combo: x" .. combo.perfect
                            end
                            score = score + 10
                            Stats.perfect = Stats.perfect + 1
                        elseif dist <= 50 then
                            hit_text = "GOOD"
                            if lane_wiggles[i] then lane_wiggles[i]:pluck(20) end
                            combo.perfect = 0
                            combo.good = combo.good + 1
                            if combo.good > 1 then
                                combo.text = "Good combo: x" .. combo.good
                            end
                            score = score + 5
                            Stats.good = Stats.good + 1
                        end
                        table.remove(notes, j)
                        return
                    end
                end
            end

            
            combo.perfect = 0
            combo.good = 0
            combo.text = ""
            hit_text = "MISS"
            if lane_wiggles[i] then lane_wiggles[i]:pluck(10) end
            score = score - 3
            Stats.miss = Stats.miss + 1
        end
    end
end

function Game.draw()
    if player.anim and player.sprite_sheet then
        player.anim:draw(player.sprite_sheet, 750, player.y, nil, nil)
    end

    for _, note in ipairs(notes) do
        draw_note("fill", note.x, note.y, "rectangle")
    end

    draw_hit_line("fill")

    for i = 1, #lane_wiggles do
        lane_wiggles[i]:draw()
    end

    if hit_text ~= "" then
        love.graphics.print(hit_text, 10, screen.h - 25)
    end

    love.graphics.print("Score: " .. tostring(score), 10, 30)

    if combo.text ~= "" then
        love.graphics.print(combo.text, 625, 175)
    end

    local mouse_x, mouse_y = love.mouse.getPosition()
    love.graphics.print("Mouse X: " .. mouse_x .. "  Y: " .. mouse_y, 10, 10)
end

return Game