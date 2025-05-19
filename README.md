
# dependecies
- [pecs](https://github.com/jesstelford/pecs)
    - for tests: `/pecs/pecs.lua`

# details
- square brackets means `nil`able

# Functions

## `call(funcs)`
calls a function or a list of function, checking type
- `funcs`: a function or a table of functions

## `moveToward(from, to, delta)`
interpolates a value linearly, from `from` to `to`, with a change of `delta`


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
draws the rectangle outline
- x, y: draw at x and y using the x and y properties as offset
    - default: do not draw at x and y

### `:getOffset(x, y)`
returns a new rectangle at the offset

### `:isIntersecting(r)`
checks if this rectangle and another are intersecting
- `r`: other rectangle


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
coordinates of entity

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


## `Delete`
queues deletion of the entity

`new.Delete(onDelete)`
- onDelete: can be
    - a function called when deleted
    - an array of functions all called when deleted


## `Physics`

### `Velocity`
allows movement of the entity

`new.Velocity([x, y])`
- x, y coordinates
    - default: 0


### `Gravity`
applies gravity to the velocity component

`new.Gravity(str, lim)`
- str: strength of gravity
- lim: limit of gravity


### `Collision`
inherits from `Rectangle`.

`new.Collision([onCollide, x, y, w, h])`
- `onCollide`: calls this function or list of functions when colliding. Has the following parameters:
    - `vel`: velocity as a `Position` object
- `x`, `y`, `w`, `h`: rectangle properties of collision
    - default: a 8x8, centered rectangle


# Systems

## `GraphicsSystem()`
calls the following systems:

### `SpriteSystem()`
draws all sprites

### `SpriteGroupSystem()`
draws all sprite groups


## `DeleteSystem()`
deletes all entities with Delete component


## `PhysicsSystem(dt, isSolid)`
calls the following systems:
- `dt`: delta time
- `isSolid`: custom function placed in the velocity system to check for solid somethings. Parameters:
    - `pos`: position
    - `vel`: velocity
    - `rect`: rectangle of collision

### `GravitySystem(dt)`
applies gravity

### `VelocitySystem(dt, [isSolid])`
applies velocity
- `isSolid`: can be `nil`
