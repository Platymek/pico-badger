
Event = {}

setmetatable(Event, {
    
    __call = function(self, ...)

        local e = {}
        local funcs = {...}

        function addFuncs(self, funcs)

            if type(funcs) == "function" then self[funcs] = true return end

            for _, val in ipairs(funcs) do

                if type(val) == "function" then self[val] = true end
            end

            for ind, val in pairs(funcs) do

                if type(ind) == "function" then self[ind] = true end
                if type(val) == "function" then self[val] = true end
            end
        end

        for _, val in ipairs(funcs) do

            addFuncs(e, val)
        end

        setmetatable(e, {

            __index = Event,
        
            __add = function(self, funcs)

                addFuncs(self, funcs)
                return self
            end,
            
            __sub = function(self, func)

                if type(func) == "function" then

                    self[func] = nil

                elseif type(func) == "table" then

                    for ind, val in pairs(func) do

                        if ind == "function" then self[ind] = nil end
                        if val == "function" then self[val] = nil end
                    end
                end

                return self
            end,

            __call = function (self, ...)

                for func, _ in pairs(self) do func(...) end
            end,
        })

        return e
    end
})
