
-- functions

function call(funcs, ...)

	if type(funcs) == "function" then

		funcs(...)
	else
		for _, f in ipairs(funcs) do

			f(...)
		end
	end
end

function moveToward(from, to, delta)

    if abs(to - from) <= delta then return to end
    return from + sgn(to - from) * delta
end


-- classes

-- -- position

Position = {}

function Position:new(x, y)

	local p = {x = x, y = y}
	setmetatable(p, self)
	self.__index = self
	return p
end

function Position:distanceSquared(p)

	local xd = self.x - p.x
	local yd = self.y - p.y
	return xd * xd + yd * yd
end

function Position:distance(p)

	return sqrt(self:distanceSquared(p))
end


-- -- rectangle, overrides Position

Rectangle = {}
setmetatable(Rectangle, {__index = Position})

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
	self.x + (x or 0), self.y + (y or 0), self.w, self.h)
end

function Rectangle:draw(colour, x, y)

	local x1 = self.x + (x or 0)
	local y1 = self.y + (y or 0)

	rect(x1, y1, x1 + self.w - 1, y1 + self.h - 1, (colour or 7))
end

function Rectangle:isOverlapping(r)

	local ax1 = self.x
	local ax2 = ax1 + self.w
	local ay1 = self.y
	local ay2 = ay1 + self.h

	local bx1 = r.x
	local bx2 = bx1 + r.w
	local by1 = r.y
	local by2 = by1 + r.h

	return not (
		ax2 <= bx1 or bx2 <= ax1
    or  ay2 <= by1 or by2 <= ay1)
end


-- -- circle, overrides Position

Circle = {}
setmetatable(Circle, {__index = Position})

function Circle:new(r, x, y)

	local p = Position:new(x or 0, y or 0)

	setmetatable(p, self)
	self.__index = self

	local c = {r = r}
	setmetatable(c, p)
	p.__index = p

	return c
end

function Circle:isOverlapping(circle)

    -- r is max distance, d is distance between two circles
    local r = self.r + circle.r
    local d = self:distanceSquared(circle)
    return abs(r * r) > abs(d)
end

function Circle:draw(colour, x, y, notFill)

	local cx1 = self.x + (x or 0) - self.r
	local cy1 = self.y + (y or 0) - self.r
	local cx2 = self.x + (x or 0) + self.r - 1
	local cy2 = self.y + (y or 0) + self.r - 1

	if notFill then
		
		oval(cx1, cy1, cx2, cy2, (colour or 7))
	else
		ovalfill(cx1, cy1, cx2, cy2, (colour or 7))
	end
end

function Circle:getOffset(x, y)

	return Circle:new(
	self.r, self.x + (x or 0), self.y + (y or 0))
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

function getBadgerComponents(w)

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

	-- -- sprite

	c.Sprite = w.component(Sprite:new(0, 0))

	function c.new.Sprite(index, x, y, w, h, flip_x, flip_y)

		local s = Sprite:new(index, (x or -4), (x or -4), w, h, flip_x, flip_y)
		local spr = c.Sprite(s)

		setmetatable(spr, s)
		s.__index = s

		return spr
	end


	-- -- sprite group

	c.SpriteGroup = w.component({})

	function c.new.SpriteGroup(...)

		local sg = c.SpriteGroup({...})
		return sg
	end


	-- camera

	c.Camera = w.component({})

	function c.new.Camera()

		return c.Camera()
	end


	-- delete

	c.Delete = w.component({onDelete = nil})

	function c.new.Delete(onDelete)

		return c.Delete({onDelete = onDelete})
	end


	-- physics

	-- -- collision

	c.Collision = w.component()

	function c.new.Collision(onCollide, x, y, w, h)
		
		local rect = Rectangle:new(x or -4, y or -4, w or 8, h or 8)

		local col = c.Collision({
			
			onCollide = onCollide
		})

		setmetatable(col, {__index = rect})

		return col
	end


	-- -- velocity

	c.Velocity = w.component()

	function c.new.Velocity(x, y)
		
		local v = Position:new(x or 0, y or 0)
		local vel = c.Velocity(v)
		vel.onFloor = false

		setmetatable(vel, v)
		v.__index = v

		return vel
	end


	-- -- gravity

	c.Gravity = w.component()

	function c.new.Gravity(str, lim)

		return c.Gravity({str = str, lim = lim})
	end


	-- systems

	-- -- graphics

	c.SpriteSystem = w.system({c.Sprite, c.Position},
	
	function(e)
	
		local pos = e[c.Position]
		e[c.Sprite]:draw(pos.x, pos.y)
	end)


	c.SpriteGroupSystem = w.system({c.SpriteGroup, c.Position},
	
	function(e)
	
		local pos = e[c.Position]
		local sg  = e[c.SpriteGroup]

		for _, s in ipairs(sg) do

			s:draw(pos.x, pos.y)
		end
	end)

	
	local function getAvOfPos(ents)

		local totalX = 0
		local totalY = 0
		local total = 0

		for _, e in pairs(ents) do

			totalX += e[c.Position].x
			totalY += e[c.Position].y
			total += 1
		end

		if total > 0 then

			return Position:new(
				totalX / total, totalY / total)
		else
			return nil 
		end
	end


	function c.CameraSystem(getFocus)

		local ents = w.query({c.Position, c.Camera})
		local focus = getFocus and getFocus(ents) or getAvOfPos(ents)
		if focus then camera(focus.x - 64, focus.y - 64) end
	end


	function c.GraphicsSystem(getFocus)

		c.SpriteSystem()
		c.SpriteGroupSystem()
		c.CameraSystem(getFocus)
	end


	-- -- delete

	c.DeleteSystem = w.system({c.Delete},

	function (e)
		
		call(e[c.Delete].onDelete)
		w.queue(function() w.remove(e) end)
	end)


	-- -- physics
	
	-- helper function for velocity system
	local function velCheck(ent, pos, col, vel, isSolid, checkY)

		local startPos = flr(checkY and pos.y or pos.x)
		local endPos = flr(checkY and pos.y + vel.y or pos.x + vel.x)
		local step = sgn(endPos - startPos)

		-- if pixel difference, check each pixel
		if startPos != endPos then
			for i = startPos, endPos, step do
			
				local newPos = checkY and 
					Position:new(pos.x, i) or 
					Position:new(i, pos.y)
			
				local polarVel = checkY and 
					Position:new(0, vel.y) or 
					Position:new(vel.x, 0) 
			
				if isSolid(ent, newPos, polarVel, col) then
					
					return {
						new = (checkY and newPos.y or newPos.x) - step,
						collision = true }
				end
			end
		end

		return {
			new = checkY and pos.y + vel.y or pos.x + vel.x,
			collision = false }
	end


	c.VelocitySystem = w.system({c.Velocity, c.Position},

	function (e, dt, isSolid)
		
		local pos = e[c.Position]
		local vel = e[c.Velocity]
		local col = e[c.Collision]

		local dtVel = Position:new(vel.x * dt, vel.y * dt)

		if not col or not isSolid then

			pos.x += dtVel.x
			pos.y += dtVel.y
			return nil
		end

		local xCol = velCheck(e, pos, col, dtVel, isSolid, false)
		local yCol = velCheck(e, pos, col, dtVel, isSolid, true)

		if xCol.collision then 

			if col.onCollide then call(col.onCollide, Position:new(vel.x, 0)) end
		end

		if yCol.collision then 

			if col.onCollide then call(col.onCollide, Position:new(0, vel.y)) end
		end

		pos.x = xCol.new
		pos.y = yCol.new
	end)


	c.GravitySystem = w.system({c.Gravity, c.Velocity},

	function (e, dt)
		
		local g = e[c.Gravity]
		local v = e[c.Velocity]

		v.y = moveToward(v.y, g.lim, g.str * dt)
	end)

	function c.PhysicsSystem(dt, isSolid)

		c.GravitySystem(dt)
		c.VelocitySystem(dt, isSolid)
	end


	return c
end
