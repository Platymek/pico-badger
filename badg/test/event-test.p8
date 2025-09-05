pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

#include ../event.lua

function newLine()

    print("\n")
end

f1 = function (message)

    print("- " .. message .. " -")
end

f2 = function (message)

    print("! " .. message .. " !")
end

f3 = function (message)

    print("? " .. message .. " ?")
end

e = Event({ f1 })
e("hello world")

e = Event(f1)
e("hello world")

e = Event(e)
e("hello world")

e = e + f2
e = e + f3
e("hello world again")

e = e - f2
e = e - f3
e("hello world again again")

e += { f2, f3 }
e("hello world almost there...")

e2 = Event(f1)
e2 += e
e("hello world final!")
