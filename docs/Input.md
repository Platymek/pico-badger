`Input(inputs)`
`inputs` is a list of inputs which are tables that can have the following values (and any others)
- `:trig(...)`:
	- if `true` is returned, triggers the input
	- **not optional**: input will not trigger without this
- `:deTrig(...)`:
	- if `true` is returned, de-triggers this input
	- called the frame after triggered
	- optional: de-triggers immediately if `nil`
- `:onTrig()`:
	- on trigger
- `:onDeTrig()`:
	- on de-trigger
- `:onCheck()`:
	- on checking if the input is triggered
	- if `true` is returned, de-triggers this input
	- optional

returns a table which:
- is the same list of inputs which can be changed
- metamethods have been given
- **calling**: manages inputs. Any parameters are passed through to trigger functions
  `input(...)`
- **indexing**: if an input is passed as a key, returns `true` if triggered