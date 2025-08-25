pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include ../../math.lua
#include ../velo.lua


local vect = Vect({

    x = 16,
    y = 64
})

local veloPropSlow = VeloProp({

    accel = 8,
    decel = 16,
    max = 16,
    maintain = 8
})

local veloPropFast = VeloProp({

    accel = 16,
    decel = 16,
    max = 32,
})

local veloProp = veloPropSlow


local velo = 0
local dt = 1 / 60
local flipped = false


function _update60()

    vect.x += velo * dt

    updateFlipped()
    controlBoost()
    controlVelo()
end

function _draw()

    cls(12)
    spr(1, vect.x, vect.y, 1, 1, flipped)
    print("velocity: " .. velo, 4, 4, 1)
end


function controlVelo()

    if      btn(1) then right()
    elseif  btn(0) then left ()
    else
        stop()
    end
end


function controlBoost()

    if btn(4) or btn(5) then 

        veloProp = veloPropFast
    else
        veloProp = veloPropSlow
    end
end


function updateFlipped()

    if velo < 0 and not flipped then flipped = false
    elseif velo > 0 and flipped then flipped = true
    end
end


function right()

    if velo >= 0 then

        velo = accel({velo=velo, dt=dt, veloProp=veloProp})
    else
        velo = -rever({velo=-velo, dt=dt, veloProp=veloProp})
    end
end


function left()

    if velo > 0 then

        velo = rever({velo=velo, dt=dt, veloProp=veloProp})
    else
        velo = -accel({velo=-velo, dt=dt, veloProp=veloProp})
    end
end


function stop()

    if velo >= 0 then

        velo = decel({velo=velo, dt=dt, veloProp=veloProp})
    else
        velo = -decel({velo=-velo, dt=dt, veloProp=veloProp})
    end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700099990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770004aaaa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700049aacc990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070041aaaa190000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001d1991d10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000010000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
