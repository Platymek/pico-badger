
Rect = {}

setmetatable(Rect, {
__call = function (s, p)

    assert(p.pos and p.w and p.h)

    local r = {

        wHalf = function(s) return s.w / 2 end,
        hHalf = function(s) return s.h / 2 end,
        x1 = function(s) return s.pos.x - s.wHalf end,
        x2 = function(s) return s.pos.x + s.wHalf end,
        y1 = function(s) return s.pos.y - s.hHalf end,
        y2 = function(s) return s.pos.y + s.hHalf end,
        shape = "rectangle",
    }

    setmetatable(p, {__index = function(s, i, p) 

        local f = r[i]

        if f then

            return type(f) == "function" and f(s, p) or f
        else
            return Rect[i]
        end
    end})

    return p
end})

function Rect:draw(p)

    local f = (p.fill == false) and rect or rectfill
    f(
        self.x1 + (p.x or 0), 
        self.y1 + (p.y or 0), 
        self.x2 + (p.x or 0), 
        self.y2 + (p.y or 0),
        p.col or nil
    )
end

function Rect:off(p)

    local pos = {

        x = self.pos.x + (p.x or p.pos.x or 0),
        y = self.pos.y + (p.y or p.pos.y or 0)
    }

    return Rect {

        pos = Vect and Vect(pos) or pos,
        w = self.w + (p.w or 0),
        h = self.h + (p.h or 0),
    }
end

function Rect:pointsOverGrid(p)

    function g(c, o) return flr((c + (o or 0)) / p.gridSize) end

    local gx1 = g(self.x1, p.x)
    local gy1 = g(self.y1, p.y)
    local gx2 = g(self.x2, p.x)
    local gy2 = g(self.y2, p.y)

    local vect = function(p) return Vect and Vect{p} or p end
    local points = {}

    for x = gx1, gx2 do
        for y = gy1, gy2 do

            points[#points + 1] = vect{ x = x, y = y }
        end
    end

    return points
end

function Rect:over(p)

    return self.overs[p.shape.shape](self, p)
end

function Rect:overRect(p)

    return not(
        self.x2 <= p.shape.x1 
    or  self.x1 >= p.shape.x2
    or  self.y2 <= p.shape.y1 
    or  self.y1 >= p.shape.y2)
end

Rect.overs = {

    ["rectangle"] = Rect.overRect
}
