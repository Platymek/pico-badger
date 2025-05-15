
-- classes

Position = {}

function Position:new(x, y)

    local p = {x = x, y = y}
    setmetatable(p, self)
    self.__index = self
    return p
end


Rectangle = {}

function Rectangle:new(x, y, w, h)
    
    local p = Position:new(x, y)

    setmetatable(p, self)
    self.__index = self

    local r = {w = w, h = h}
    setmetatable(r, p)
    p.__index = p

    return r
end

function Rectangle:getOffset(x, y)

    return Rectangle:new(
    self.x + x, self.y + y, self.w, self.h)
end

function Rectangle:draw(colour, x, y)

    rect(self.x + (x or 0), self.y + (y or 0), self.w, self.h, colour)
end


Sprite = {}

function Sprite:new(index, x, y, w, h, flip_x, flip_y)

    local p = Position:new(x, y)
    
    setmetatable(p, self)
    self.__index = self

    local s = {
    index = index, x = x or 0, y = y or 0, w = w or 1, h = h or 1, 
    flip_x = flip_x or false, flip_y = flip_y or false}

    setmetatable(s, p)
    p.__index = p

    return s
end

function Sprite:draw(x, y)

    spr(self.index, self.x + (x or 0), self.y + (y or 0), 
    self.w, self.h, self.flip_x, self.flip_y)
end
