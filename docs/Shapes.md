# Shape
the following shapes all share the functions and properties listed in this header

properties:
- `pos`: origin point of the shape. Always central
## Draw Function: `Shape:draw`
`Shape:draw{ [x, y, col, fill] }`
- `x`, `y`: offset position. Default: `0`
- `col`: colour. Default: your previous colour
- `fill`: fill in the shape or not. Default: `true`
## Offset Function: `Shape:off`
gets an offset of the current shape. All shapes have this function and all parameters can be modified.
## Overlap function: `Shape:over`
returns `true` if the shapes are overlapping. Shapes may be able to overlap with shapes of different kind so see the main headings for details.

`Shape:over{ shape, [x, y] }`
- `shape`: the shape overlapping with
- `x, y`: offset position. Default: `0`
# Rectangle: `Rect`
`Rect{ pos, w, h }`
- `pos`: position. You can use `Vect`
- `w`, `h`: width and height

properties:
- `wHalf`, `hHalf` = half width and height
- `x1`, `x2`, `y1`, `y2` = corner positions
- `shape` = `"rectangle"`, the name of this shape

overlaps:
- `Rect`
## Points Overlapping Grid: `Rect:pointsOverGrid`
returns a list of points on a grid that this rectangle is overlapping

`Rect:pointsOverGrid{ gridSize, [x, y] }`
- `gridSize`: size of the squares on the grid
- `x, y`: offset position on grid. Default: `0`
- returns: list of points on grid

usage ideas:
- to check if a shape is colliding with solid tiles on a map