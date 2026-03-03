local Wiggle = {}
Wiggle.__index = Wiggle

function Wiggle.new(x, y, length, segments)
    local self = setmetatable({}, Wiggle)

    self.x = x
    self.y = y
    self.length = length
    self.segments = segments or 60

    self.amplitude = 0
    self.time = 0

    self.frequency = 35
    self.damping = 8

    return self
end

function Wiggle:update(dt)
    self.time = self.time + dt
    self.amplitude = self.amplitude * math.exp(-self.damping * dt)

    if self.amplitude < 0.01 then
        self.amplitude = 0
    end
end

function Wiggle:draw()
    for i = 0, self.segments - 1 do
        local t1 = i / self.segments
        local t2 = (i + 1) / self.segments

        local y1 = self.y + t1 * self.length
        local y2 = self.y + t2 * self.length

        local envelope1 = math.sin(math.pi * t1)
        local envelope2 = math.sin(math.pi * t2)

        local offset1 = math.sin(self.time * self.frequency) * self.amplitude * envelope1
        local offset2 = math.sin(self.time * self.frequency) * self.amplitude * envelope2

        love.graphics.line(
            self.x + offset1, y1,
            self.x + offset2, y2
        )
    end
end

function Wiggle:pluck(power)
    self.amplitude = power or 25
    self.time = 0
end

return Wiggle