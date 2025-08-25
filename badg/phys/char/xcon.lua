
function xcon(p)

    assert(p.velo and p.dt and p.veloProp)

    -- velocity and control directions
    local veloDire = p.velo == 0 and 0 or (p.velo > 0 and 1 or -1)
    local contDire = getDirection(p)
    local velo = abs(p.velo)

    if p.fastFlip and isResisting({velo = veloDire, direction = contDire}) then
        velo = fastFlipVelo(
            {velo = velo, threshold = p.fastFlipThreshold or p.veloProp.max}) 
    end

    -- if velocity is 0, accelerate in a direction
    if velo == 0 and contDire ~= 0 then
        return accel(velo, p.dt, p.veloProp) * contDire 
    end

    return accelInDirection(
        {velo=velo, dt=p.dt, direction=contDire * veloDire, veloProp=p.veloProp}) 
        * veloDire
end

function accelInDirection(p)

    assert(p.velo and p.dt and p.direction)

    if p.direction < 0 then return 
        rever(p.velo, p.dt, p.veloProp) end

    if p.direction > 0 then return 
        accel(p.velo, p.dt, p.veloProp) end

    return decel(p.velo, p.dt, p.veloProp)
end

function getDirection(p)

    if not p.left then p.left = false end
    if not p.right then p.right = false end
    return (p.right and 1 or 0) - (p.left and 1 or 0)
end

function fastFlipVelo(p)

    if abs(p.velo) < p.threshold then return 0 end
    return p.velo
end

function isResisting(p)

    if p.velo == 0 and p.direction == 0 then 
        return false 
    end

    return (p.velo > 0 and p.direction < 0) 
        or (p.velo < 0 and p.direction > 0)
end
