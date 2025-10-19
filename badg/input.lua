
Input = {mt = {}}
IMT = {}

function IMT:__call(inputs)

    local trigged = {}

    local function trig(inp)
        trigged[inp] = true
        if inp.onTrig then
            inp:onTrig() end
    end

    local function deTrig(inp)
        trigged[inp] = nil
        if inp.onDeTrig then
            inp:onDeTrig() end
    end

    local im = {}

    function im:__call(...)

        local toTrig = {}
        local toDeTrig = {}

        for _, inp in ipairs(inputs) do
            if not trigged[inputs] and inp.trig and inp:trig(...) then
                toTrig[#toTrig + 1] = inp end end

        for inp, _ in pairs(trigged) do
            if (inp.deTrig and inp:deTrig(...)) or not inp.deTrig then
                toDeTrig[#toDeTrig + 1] = inp end end

        for _, inp in ipairs(toTrig) do
            trig(inp) end
        for _, inp in ipairs(toDeTrig) do
            deTrig(inp) end
    end

    function im:__index(inp)

        if trigged[inp] 
        then
            if inp.onCheck and inp:onCheck() == false then
                deTrig(inp) end
            return true
        end
        return false
    end

    setmetatable(inputs, im)
    return inputs
end

setmetatable(Input, IMT)
