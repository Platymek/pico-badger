
JumpProp = {}

setmetatable(JumpProp, {
    
    __call = function(self, p)

        assert(p.timeToPeak, p.timeToFall, p.maxHeight, 
            "timeToPeak, timeToFall, and maxHeight must be provided")

        p.jumpGrav = getJumpGrav(p)
        p.fallGrav = p.terminal and getFallGravTerminal(p) or getFallGrav(p)
        p.jumpVelo = getJumpVelo({ jumpGrav = p.jumpGrav, maxHeight = p.maxHeight })
        p.minVelo = p.minHeight and getMinJumpVelo({ jumpGrav = p.jumpGrav, minHeight = p.minHeight }) or 0
        p.terminal = p.terminal or getTerminal({ fallGrav = p.fallGrav, timeToFall = p.timeToFall })
        p.fall = fall

        function p:getJumpVelo(p2)

            return getJumpVelo{ jumpGrav = p.jumpGrav, maxHeight = p2.height }
        end

        setmetatable(p, {

            __index = JumpProp
        })

        return p
    end
})

function fall(self, p)

    if isFall(p.velo) then

        return min(p.velo + self.fallGrav * p.dt, self.terminal)
    else
        return p.velo + self.jumpGrav * p.dt
    end
end

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
