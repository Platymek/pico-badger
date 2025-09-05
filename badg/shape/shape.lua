
Shape = {}

setmetatable(Shape, {
__call = function (p)

    assert(p.shape and p.draw and p.offset and p.isOver 
    and p.origin and p.origin.x and p.origin.y)

    return setmetatable(p, {__index = Shape})
end})
