
-- classes


-- -- position

Position = {}

function Position:new(x, y)

	local p = {x = x, y = y}
	setmetatable(p, self)
	self.__index = self
	return p
end


-- -- rectangle

Rectangle = {}

function Rectangle:new(x, y, w, h)
    
	local p = Position:new(x, y)

	setmetatable(p, self)
	self.__index = self

	local r = {w = w, h = h}
	setmetatable(r, p)
	p.__index = p

	return r
end

function Rectangle:getOffset(x, y)

	return Rectangle:new(
	self.x + x, self.y + y, self.w, self.h)
end

function Rectangle:draw(colour, x, y)

	rect(self.x + (x or 0), self.y + (y or 0), self.w, self.h, colour)
end


-- -- sprite

Sprite = {}

function Sprite:new(index, x, y, w, h, flip_x, flip_y)

	local p = Position:new(x, y)
	
	setmetatable(p, self)
	self.__index = self

	local s = {
	index = index, x = x or 0, y = y or 0, w = w or 1, h = h or 1, 
	flip_x = flip_x or false, flip_y = flip_y or false}

	setmetatable(s, p)
	p.__index = p

	return s
end

function Sprite:draw(x, y)

	spr(self.index, self.x + (x or 0), self.y + (y or 0), 
	self.w, self.h, self.flip_x, self.flip_y)
end


-- components

function getComponents(w)

	local c = {}
	c.new = {}


	-- position

	c.Position = w.component(Position:new(0, 0))

	function c.new.Position(x, y)

		local p = Position:new(x, y)
		local pos = c.Position(p)

		setmetatable(pos, p)
		p.__index = p

		return pos
	end

	
	-- graphics

	-- -- components

	c.Sprite = w.component(Sprite:new(0, 0))

	function c.new.Sprite(index, x, y, w, h, flip_x, flip_y)

		local s = Sprite:new(index, (x or -4), (x or -4), w, h, flip_x, flip_y)
		local spr = c.Sprite(s)

		setmetatable(spr, s)
		s.__index = s

		return spr
	end


	c.SpriteGroup = w.component({})

	function c.new.SpriteGroup(...)

		local sg = c.SpriteGroup({...})
		return sg
	end


	-- -- systems

	c.SpriteSystem = w.system({c.Sprite, c.Position},
	
	function(e)
	
		local pos = e[c.Position]
		e[c.Sprite]:draw(0, 0)
	end)


	c.SpriteGroupSystem = w.system({c.SpriteGroup, c.Position},
	
	function(e)
	
		local pos = e[c.Position]
		local sg  = e[c.SpriteGroup]

		for _, s in ipairs(sg) do

			s:draw(pos.x, pos.y)
		end
	end)

	function c.GraphicsSystem()

		c.SpriteSystem()
		c.SpriteGroupSystem()
	end


	return c
end
