local Menu = {}

local button_height = 64
local screen = {}
local buttons = {}
local font = nil

local function newBtn(text, fn)
    return { text = text, fn = fn, now = false, last = false }
end

function Menu.load()
    font = love.graphics.newFont(32)
    screen.w = love.graphics.getWidth()
    screen.h = love.graphics.getHeight()

    table.insert(buttons, newBtn("Start game", function()
       gameState.play = true
       gameState.menu = false
       gameState.gameOver = false
       Game.start()
    end))

    table.insert(buttons, newBtn("Settings", function()
        print("Settings..")
    end))

    table.insert(buttons, newBtn("Quit game", function()
        love.event.quit(0)
    end))
end

function Menu.update(dt)
    local mx, my = love.mouse.getPosition()
    local margin = 16
    local total_height = (button_height + margin) * #buttons
    local button_width = screen.w * (1/3)

    for i, button in ipairs(buttons) do
        button.last = button.now
        button.now = love.mouse.isDown(1)

        local cursor_y = (i - 1) * (button_height + margin)
        local bx = (screen.w * 0.5) - (button_width * 0.5)
        local by = (screen.h * 0.5) - (total_height * 0.5) + cursor_y

        local hover = mx > bx and mx < bx + button_width and
                      my > by and my < by + button_height

        if button.now and not button.last and hover then
            button.fn()
        end
    end
end

function Menu.draw()
    local margin = 16
    local total_height = (button_height + margin) * #buttons
    local cursor_y = 0
    local button_width = screen.w * (1/3)

    for i, button in ipairs(buttons) do
        local bx = (screen.w * 0.5) - (button_width * 0.5)
        local by = (screen.h * 0.5) - (total_height * 0.5) + cursor_y
        local color = {0.4, 0.4, 0.5, 1.0}
        local mx, my = love.mouse.getPosition()
        
        local hover = mx > bx and mx < bx + button_width and
                      my > by and my < by + button_height

        if hover then color = {0.8, 0.8, 0.9, 1.0} end

        love.graphics.setColor(color)
        -- love.graphics.setColor(0, 0.8, 0.8) miku teal color
        love.graphics.rectangle("fill", bx, by, button_width, button_height)
        love.graphics.setColor(0, 0, 0, 1)

        local tw = font:getWidth(button.text)
        local th = font:getHeight()
        love.graphics.print(button.text, font,
            (screen.w * 0.5) - tw * 0.5,
            by + (button_height - th) * 0.5
        )

        cursor_y = cursor_y + (button_height + margin)
    end
    love.graphics.setColor(1, 1, 1, 1) 
end

return Menu