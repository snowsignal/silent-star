local Camera = require "hump/camera"

local cameraSystem = tiny.processingSystem()
cameraSystem.filter = tiny.requireAll("playerControlled", "pos")


function cameraSystem:onAddToWorld(world)
	world.camera = self
	local posx, posy = self:buildTransform(0, 0)
	self.camera = Camera(posx, posy)
end

function cameraSystem:attach()
	if self.camera then
		self.camera:attach()
	end
end

function cameraSystem:detach()
	if self.camera then
		self.camera:detach()
	end
end

function cameraSystem:onAdd(e)
	-- Immediately jump to target
	posx, posy = self:buildTransform(e.pos.x, e.pos.y)
	self.camera:lookAt(posx, posy)
	--posx, posy = self:buildTransform(e.pos.x, e.pos.y)
	--self.camera = Camera(posx, posy)
end

function cameraSystem:buildTransform(px, py)
	local xcenter = love.graphics.getWidth() / 2
	local ycenter = love.graphics.getHeight() / 2
        local tx = px
        local ty = py

        if tx < xcenter then
                tx = xcenter
        end
	if ty < ycenter then
		ty = ycenter
	end
        if tx > self.world.width  * self.world.tilewidth - xcenter  then
                tx = self.world.width  * self.world.tilewidth - xcenter
        end
        if ty > self.world.height * self.world.tileheight - ycenter then
                ty = self.world.height * self.world.tileheight - ycenter
        end

        tx = math.floor(tx)
        ty = math.floor(ty)

	return tx, ty
end

function cameraSystem:process(e)
	posx, posy = self:buildTransform(e.pos.x, e.pos.y)
	self.camera:lockPosition(posx, posy, Camera.smooth.damped(8))
end

return cameraSystem
