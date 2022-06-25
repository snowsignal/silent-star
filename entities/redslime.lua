local Vector = require 'hump.vector'

local defaultMoveSpeed = 2.0

local RedSlime = {}

function RedSlime:new(x, y, movespeed)
	local ms = movespeed or defaultMoveSpeed
	return {
		monster = {
			type = "redslime",
			movespeed = ms,
			direction = 1 -- either 1 or -1
		},
		pos = Vector(x, y),
		size = Vector(32, 32),
		vel  = Vector()
	}
end

return RedSlime
