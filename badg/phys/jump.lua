
JumpProp = {

    fall = function(self, p)

        if isFall(p.currVelo) then

            return min(p.currVelo + self.fallGrav * p.dt, self.terminal)
        else
            return p.currVelo + self.jumpGrav * p.dt
        end
    end
}

setmetatable(JumpProp, {
    
    __call = function(self, p)

        assert(p.timeToPeak, p.timeToFall, p.maxHeight, 
            "timeToPeak, timeToFall, and maxHeight must be provided")

        local j = {

            jumpGrav = getJumpGrav(p),
            fallGrav = p.terminal and getFallGravTerminal(p) or getFallGrav(p),
        }

        j.jumpVelo = getJumpVelo({ jumpGrav = j.jumpGrav, maxHeight = p.maxHeight })
        j.minVelo = p.minHeight and getMinJumpVelo({ jumpGrav = j.jumpGrav, minHeight = p.minHeight }) or 0
        j.terminal = p.terminal or getTerminal({ fallGrav = j.fallGrav, timeToFall = p.timeToFall })

        setmetatable(j, {

            __index = JumpProp
        })

        return j
    end
})

function getGrav(p)

    return (2 * p.height) / (p.time ^ 2)
end

function getFallGrav(p)

    return getGrav({

        time = p.timeToFall,
        height = p.maxHeight
    })
end

function getJumpGrav(p)

    return getGrav({

        time = p.timeToPeak,
        height = p.maxHeight
    })
end

function getFallGravTerminal(p)

    assert(p.terminal * p.timeToFall > p.maxHeight, "terminal velocity must be above\n" .. p.maxHeight / p.timeToFall)
    return (1 / (2 * (p.terminal * p.timeToFall - p.maxHeight))) * p.terminal * p.terminal
end

function getJumpVelo(p)

    return sqrt(2) * sqrt(p.jumpGrav) * sqrt(p.maxHeight)
end

function getTerminal(p)

    return p.fallGrav * p.timeToFall
end

function getMinJumpVelo(p)

    return sqrt(2) * sqrt(p.jumpGrav) * sqrt(p.minHeight)
end

function isFall(velo)

    return velo > 0
end
