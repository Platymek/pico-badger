
function moveToward(p)

    if abs(p.to - p.from) <= p.delta then return p.to end
    return p.from + sgn(p.to - p.from) * p.delta
end

Vect = {}

setmetatable(Vect, {
    
    __call = function(self, p)

        local v = {

            x = p.x or 0,
            y = p.y or 0,
        }

        v.__index = Vect
        return v
    end
})