
# dependecies
- [pecs](https://github.com/jesstelford/pecs)
    - for tests: `/pecs/pecs.lua`

# details
- square brackets means `nil`able

# classes

## Position

### `:new(x, y)`
Creates a new position object
- x: x coordinate
- y: y coordinate


## Rectangle
inherits from position, so uses all the same functions

### `:new(x, y, w, h)`
creates a new rectangle object
- w, h: dimensions of rectangle

### `:draw(colour, [x, y])`
Draws the rectangle outline
- x, y: draw at x and y using the x and y properties as offset
    - default: do not draw at x and y


## Sprite
inherits from position, so uses all the same functions
- index: sprite index on pico spritesheet
- x, y: offset of sprite
- w, h: dimensions from spritesheet in percentage
- flip_x, flip_y: flip in x or y

### `:new(index, x, y, [w, h, flip_x, flip_y])`
Creates a new sprite object

defaults:
- w, h: `1`
- flip_x, flip_y: `false`

### `:draw([x, y])`
Draws the sprite
- x, y: draw at x and y using the x and y properties as offset
    - default: do not draw at x and y


# Components
All constructors are found in the `.new` table. For example:
```lua
local c = getComponents(world)
local e = world.entity()
e += c.new.Position(3, 12)
e += c.new.Sprite(4)
```

## `getComponents(world)`
Creates components and returns a table containing them
- world: pecs world

## `Position`
coordinates of character

`new.Position(x, y)`
- x, y: coordinates

## `Sprite`
sprite

`new.Sprite(index, x, y, [w, h, flip_x, flip_y])`
- same as Sprite class
    - x and y default to -4 to auto center

### `SpriteGroup`
group of sprites which are all drawn at once

`new.SpriteGroup(...)`
- variadic function where all parameters are sprites


# Systems

## `GraphicsSystem()`
calls the following systems:

### `SpriteSystem()`
draws all sprites

### `SpriteGroupSystem()`
draws all sprite groups
