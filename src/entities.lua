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

Slime = {
	id = "slime",
	texture = love.graphics.newImage("assets/enemies/slime-anim1.png"),
	frames = {
		love.graphics.newImage("assets/enemies/slime-anim1.png"),
		love.graphics.newImage("assets/enemies/slime-anim2.png"),
		love.graphics.newImage("assets/enemies/slime-anim3.png"),
		love.graphics.newImage("assets/enemies/slime-anim4.png"),
	},
	scaleX = 3,
	scaleY = 3,
	height = 24,
	width = 48,
	offsetX = 0,
	offsetY = 8,
	isEnemy = true,
	moveLeft = true,
	movementFrames = 0
}

function Slime.draw(this)
	this.movementFrames = this.movementFrames + 1
	if (this.movementFrames >= 40) then
		this.movementFrames = 0
	end
	this.texture = Slime.frames[1 + math.floor(this.movementFrames / 10)]
	love.graphics.setColor(1, 1, 1, 1)
	--love.graphics.rectangle("fill", Camera.convert("x", this.x), Camera.convert("y", this.y), this.width, this.height)
	love.graphics.draw(this.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, Slime.scaleX, Slime.scaleY, Slime.offsetX, Slime.offsetY)
end

function Slime.behaivor(this)
	if (this.moveLeft) then
		this.x = this.x + 1
		this.checkX = this.x + this.width + 1
		this.checkY = this.y + this.height + 1
	else
		this.x = this.x - 1
		this.checkX = this.x + 1
		this.checkY = this.y + this.height + 1
	end
	if (Heartbeat.getTile(this.checkX, this.checkY) == nil) then
		this.moveLeft = not this.moveLeft
	end
end

