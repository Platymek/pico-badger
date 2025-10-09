
function State(p)

    return p and {

        into = p.into,
        out = p.out,
        can = p.can,
        is = p.is,
        props = p.props,
        isState = true
    } or {}
end

local checkCan
StateMachine = {}
setmetatable(StateMachine, {

    __call = function(self, p)

        local def = p.default or State{}
        local cur = p.current or State{}
        if def.into then 
            def.into() end
        if cur.into then 
            cur.into() end

        local function set(s)

            if cur.out then
                cur.out() end
            cur = s
            if cur.into then
                cur.into() end
        end

        local function can()

            local ns -- new state
            repeat
                ns = checkCan({cur.can, def.can}, p)
                if ns
                then
                    if not ns.isState then
                        stop("State was not returned") end
                    set(ns)
                end
            until not ns
        end

        return setmetatable({

            isIn = function(self, state)

                local s = state or self
                if s.isState then
                    return cur == s end
                return false
            end
        }, {

            __call = function(self, p)

                can(p)
                updateIs({cur.is, def.is}, p)
            end,

            __index = function(self, i)
                
                if cur.props and cur.props[i] ~= nil then
                    return cur.props[i]
                elseif def.props then
                    return def.props[i] 
                end
            end,
        })
    end
})

function checkCan(cans, p)

    for _, can in ipairs(cans)
    do
        local ns -- new state
        if type(can) == "table" then
            ns = checkCan(can, p)
        elseif type(can) == "function" then
            ns = can(dt)
        end
        if ns then 
            return ns end
    end
end

function updateIs(iss, p)

    for i, is in ipairs(iss)
    do
        if type(is) == "table" then
            updateIs(is, p)
        elseif type(is) == "function" then
            is(p)
        end
    end
end
