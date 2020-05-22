Terminal = {
	id = "terminal",
	texture = love.graphics.newImage("assets/misc/terminal.png"),
	height = 70,
	width = 40,
	isEnemy = false
}

function Terminal.draw(this)
	local scaleX = 2
	local scaleY = 2
	local offsetX = 10
	local offsetY = 13
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(Terminal.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, scaleX, scaleY, offsetX, offsetY)
end

function checkTerminalRange()
	for i=1,#Heartbeat.entities do
		if (Heartbeat.entities[i].id == "terminal" and math.abs(Heartbeat.entities[i].x - Heartbeat.player.x) < 60) then
			return true
		end
	end
	return false
end

BasicShot = {
	id = "basic_shot",
	texture = love.graphics.newImage("assets/proton/shot/shot1.png"),
	scaleX = 1.2,
	scaleY = 1.2,
	height = 16,
	width = 16,
	isEnemy = true
}

function BasicShot.draw(this)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(BasicShot.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, BasicShot.scaleX, BasicShot.scaleY, 0, 0)
end

function BasicShot.behaivor(this)
	if (Heartbeat.player.forwardFace) then
		if (this.dx ~= -12) then
			this.dx = 12
		end
	else
		if (this.dx ~= 12) then
			this.dx = -12
		end
	end
	this.dy = -.5
end

function BasicShot.onCollision(this, collidedObject)
	Heartbeat.removeEntity(this)
	if (collidedObject.id == "door") then
		Heartbeat.removeTile(collidedObject)
	end
	print(collidedObject.id)
end
