-- trans.lua
local flux = require "lib/flux"

local trans = {}

local rect = {
    x = 0,
    y = 0,
    w = 0,
    h = 0
}

function trans.start(time, ease_type, dir, nextState)
    love.graphics.clear()
    rect = {x = 0, y = 0, w = 0, h = 0} -- reset each time
    if dir == "down" then
        rect.w = love.graphics.getWidth()
        flux.to(rect, time, {h = love.graphics.getHeight()}):ease(ease_type)
            
            :oncomplete(nextState or function ()
                
            end):after(rect, (time/2), {y = love.graphics.getHeight()}):ease(ease_type)
    end
    if dir == "right" then
        rect.h = love.graphics.getHeight()
        flux.to(rect, time, {w = love.graphics.getWidth()}):ease(ease_type)
            :after(rect, (time/2), {x = love.graphics.getWidth()}):ease(ease_type)
            :oncomplete(nextState or function ()
                
            end)
    end
end

function trans.update(dt)
    flux.update(dt)
end

function trans.draw()
    love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h)
end

return trans