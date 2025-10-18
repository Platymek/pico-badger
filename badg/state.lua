
function State(p)

    return p and {

        into = p.into,
        out = p.out,
        can = p.can or {},
        is = p.is or {},
        props = p.props or {},
        isState = true
    } or {}
end

local checkCan
StateMachine = {}
setmetatable(StateMachine, {

    __call = function(self, p)

        local def = p.default or State{}
        local cur = p.current or State{}

        local cant = {}
        local isnt = {}

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
            
            cant = {}
            for i, v in pairs(cur.can)
            do
                if v == false then
                    cant[i] = true end
            end
            isnt = {}
            for i, v in pairs(cur.is)
            do
                if v == false then
                    isnt[i] = true end
            end
        end

        local function can(p)

            local ns -- new state
            repeat
                ns = checkCan({cur.can, def.can}, cant, p)
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
                updateIs({cur.is, def.is}, isnt, p)
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

function checkCan(canTable, cantTable, p)

    for i, can in ipairs(canTable)
    do
        local ns -- new state
        if type(can) == "table" then
            ns = checkCan(can, cantTable, p)
        elseif type(can) == "function" 
            and not cantTable[can] then
            ns = can(dt)
        end
        if ns then 
            return ns end
    end
end

function updateIs(isTable, isntTable, p)

    for i, is in ipairs(isTable)
    do
        if type(is) == "table" then
            updateIs(is, isntTable, p)
        elseif type(is) == "function" 
            and not isntTable[is] then
            is(p)
        end
    end
end
