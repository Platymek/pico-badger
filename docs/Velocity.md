simple velocity in one dimension. Suited for x axis velocity
# Velocity Properties: `VeloProp`
properties for velocity used by velocity functions

`VeloProp({ accel, decel, max, [min], [maintain] })`
- `accel`: acceleration
- `decel`: deceleration
- `max`: max speed
- `min`: minimum speed. Default: `0`
- `maintain`: the deceleration when trying to accelerate above the max speed. Default: the velocity is snapped to the max speed

all these properties are public
# Acceleration Functions: `accel`, `decel` and `rever`
- `accel`: accelerates
- `decel`: decelerates
- `rever`: applies acceleration and deceleration strengths towards min speed

`accel({ velo, dt, veloProp })`
`decel({ velo, dt, veloProp })`
`rever({ velo, dt, veloProp })`
- `velo`: current velocity
- `dt`: delta time
- `veloProp`: velocity properties. Use `VeloProp()`
- **returns:** new velocity