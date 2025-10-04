
VeloProp = {}

setmetatable(VeloProp, {
    
    __call = function(self, p)

        assert((p.insta or p.accel) and p.decel and p.max)

        local v = {

            accel = p.accel,
            decel = p.decel,
            insta = p.insta,
            max = p.max,

            min = p.min or 0,
            maintain = p.maintain,
        }

        setmetatable(v, {

            __index = VeloProp
        })
        
        return v
    end
})

function accel(p)

    assert(p.velo and p.dt and p.veloProp)

    if p.velo > p.veloProp.max and p.veloProp.maintain then
        local decel = p.veloProp.maintain or p.veloProp.decel
        return max(p.velo - decel * p.dt, p.veloProp.max) 
    end

    if p.velo < p.veloProp.max and not p.veloProp.insta then
        return min(p.velo + p.veloProp.accel * p.dt, p.veloProp.max) end

    return p.veloProp.max
end

function decel(p)

    assert(p.velo and p.dt and p.veloProp)

    if p.velo == p.veloProp.min then return p.veloProp.min end
    return max(p.velo - p.veloProp.decel * p.dt, p.veloProp.min)
end

function rever(p)

    assert(p.velo and p.dt and p.veloProp)

    if p.velo == p.veloProp.min then return p.veloProp.min end
    if p.veloProp.insta and abs(p.velo) < p.veloProp.max then return p.veloProp.min end
    return max(p.velo - (p.veloProp.decel + (p.veloProp.accel or 0)) * p.dt, p.veloProp.min)
end
