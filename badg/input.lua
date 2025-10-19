
Input = {mt = {}}
IMT = {}

function IMT:__call(inputs)

    local untrig = {}
    local trigged = {}
    for _, v in ipairs(inputs) do
        untrig[v] = true end

    local function trig(inp)
        trigged[inp] = true
        untrig[inp] = nil
        if inp.onTrig then
            inp:onTrig(p) end
    end

    local function deTrig(inp)
        untrig[inp] = true
        trigged[inp] = nil
        if inp.onDeTrig then
            inp:onDeTrig(p) end
    end

    local im = {}

    function im:__call(p)

        local toTrig = {}
        local toDeTrig = {}

        for inp, _ in pairs(untrig) do
            if inp.trig and inp:trig(p) then
                toTrig[#toTrig + 1] = inp end end

        for inp, _ in pairs(trigged) do
            if inp.deTrig and inp:deTrig(p) then
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
