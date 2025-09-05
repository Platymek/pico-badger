
function rayc(p)

    assert(p.initPosi and p.dist and p.isSolid and p.dist ~= 0)

    local startp = flr(p.initPosi)
    local endp = flr(p.initPosi + p.dist)
    local noColl = { coll = false, posi = p.initPosi + p.dist }

    if startp == endp then return noColl end
    local step = sgn(p.dist)

    for i = startp, endp, step do

        local c = p.isSolid(i)

        if type(c) == "table" then

            c.posi = i - step
        else
            c = { coll = c, posi = i - step }
        end

        if c.coll then

            return c
        end
    end

    return noColl
end
