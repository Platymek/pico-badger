velocity suited for gravity and jumping
# Jump Properties: `JumpProp`
properties for jumping, including variable height. Use `jumpVelo` property when you want to jump!

`JumpProp({ timeToPeak, timeToFall, maxHeight, [minHeight], [terminal] })`
- `timeToPeak`: time taken to reach peak of jump
- `timeToFall`: time taken to reach the ground after peak
- `maxHeight`: height of peak of jump
- `minHeight`: the minimum height if you want to use variable jump height. Default: `nil`
- `terminal`: the terminal velocity. Default: the velocity reached after falling from the maximum jump height 

properties (on top of parameters):
- `jumpGrav`: gravity strength when rising
- `fallGrav`: gravity strength when falling
- `jumpVelo`: initial velocity on jump
- `minVelo`: initial velocity of smallest jump
- `fall`: the `fall` function, as seen below
## Fall Function: `JumpProp:fall`
`fall(self, { velo, dt })`
- `self`: a `JumpProp` table
- `velo`: current velocity
- `dt` delta time
- returns: new velocity