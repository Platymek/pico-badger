# `xcon{}` function
returns new velocity

| parameter           | optional | description                        |
| ------------------- | -------- | ---------------------------------- |
| `velo`              | no       | current velocity                   |
| `dt`                | no       | delta time                         |
| `veloProp`          | no       | [Velocity Properties](Velocity.md) |
| `left`              | yes      | move left                          |
| `right`             | yes      | move right                         |
| `fastFlip`          | yes      | boolean. Flip if below threshold   |
| `fastFlipThreshold` | yes      | defaults to max speed              |
you may prefer to use `insta` in `veloProp` over `fastFlip` for instant max speed