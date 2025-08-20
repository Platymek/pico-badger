
VeloProp = {}

setmetatable(VeloProp, {
    
    __call = function(self, p)

        assert(p.accel and p.decel and p.max, "accel, decel, and max speed must be provided")

        local v = {

            accel = p.accel,
            decel = p.decel,
            max = p.max,

            min = p.min or 0,
            maintain = p.maintain,
        }

        v.__index = VeloProp
        return v
    end
})

function accel(currVelo, dt, veloProp)

    if currVelo < veloProp.max then
        return min(currVelo + veloProp.accel * dt, veloProp.max) end

    if currVelo > veloProp.max and veloProp.maintain then
        return max(currVelo - veloProp.maintain * dt, veloProp.max) end

    return veloProp.max
end

function decel(currVelo, dt, veloProp)

    if currVelo == veloProp.min then return veloProp.min end
    return max(currVelo - veloProp.decel * dt, veloProp.min)
end

function rever(currVelo, dt, veloProp)

    if currVelo == veloProp.min then return veloProp.min end
    return max(currVelo - (veloProp.decel + veloProp.accel) * dt, veloProp.min)
end
