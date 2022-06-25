local Vector = require 'hump.vector'

local movespeed = 2.0

local GreenSlime = {}

function GreenSlime:new(x, y)
	return {
		monster = {
			type = "greenslime",
			movespeed = movespeed,
			direction = 1 -- either 1 or -1
		},
		pos = Vector(x, y),
		size = Vector(32, 32),
		vel  = Vector()
	}
end

return GreenSlime
