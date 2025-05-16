
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

### `:new(index, x, y, [w, h, flip_x, flip_y])`
Creates a new sprite object
- index: sprite index on pico spritesheet
- x, y: offset of sprite
- w, h: dimensions from spritesheet in percentage
    - default: `1`
- flip_x, flip_y: flip in x or y
    - default: `false`

### `:draw([x, y])`
Draws the sprite
- x, y: draw at x and y using the x and y properties as offset
    - default: do not draw at x and y

# Components

## `getComponents(world)`
Creates components and returns a table containing them
- world: pecs world

## `Position`
coordinates of character

### `newPosition(x, y)`
- same as Position class

## `Sprite`

### `newSprite(index, x, y, [w, h, flip_x, flip_y])`
- same as Sprite class
    - x and y default to -4 to auto center
