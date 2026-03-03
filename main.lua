Menu = require "menu"
Game = require "game"
gameOver = require "gameOver"

gameState = {
    menu = true,  
    play = false,
    gameOver = false
}

function love.load()
    Menu.load()
    Game.load()
    gameOver.load()
end

function love.update(dt)
    if gameState.menu then
        Menu.update(dt)
    elseif gameState.play then
        Game.update(dt)
    elseif gameState.gameOver then
        gameOver.update(dt)
    end
end

function love.draw()
    if gameState.menu then
        Menu.draw()
    elseif gameState.play then
        Game.draw()
    elseif gameState.gameOver then
        gameOver.draw()
    end
end

function love.keypressed(key)
    if gameState.play then
        Game.keypressed(key)
    end
end


-- local startX = 400
-- local startY = 100
-- local length = 400
-- local segments = 60

-- local amplitude = 0
-- local time = 0

-- local frequency = 35     -- higher = tighter string
-- local damping = 8        -- higher = faster stop

-- function love.update(dt)
--     time = time + dt

--     -- Fast decay (good for rhythm feel)
--     amplitude = amplitude * math.exp(-damping * dt)

--     -- Stop tiny jitter
--     if amplitude < 0.01 then
--         amplitude = 0
--     end
-- end

-- function love.draw()
--     for i = 0, segments - 1 do
--         local t1 = i / segments
--         local t2 = (i + 1) / segments

--         local y1 = startY + t1 * length
--         local y2 = startY + t2 * length

--         -- Ends fixed
--         local envelope1 = math.sin(math.pi * t1)
--         local envelope2 = math.sin(math.pi * t2)

--         -- Vibrate sideways
--         local offset1 = math.sin(time * frequency) * amplitude * envelope1
--         local offset2 = math.sin(time * frequency) * amplitude * envelope2

--         love.graphics.line(
--             startX + offset1, y1,
--             startX + offset2, y2
--         )
--     end
-- end

-- function pluck(power)
--     amplitude = power or 25
--     time = 0
-- end

-- function love.keypressed(key)
--     if key == "space" then
--         pluck(30)
--     end
-- end 