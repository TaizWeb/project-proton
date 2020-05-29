require("lib/standard")

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
	-- Yolo, I could've done something clever with the editor but I just got lazy with adding flipping
	if (Heartbeat.levelName == "cave4") then
		scaleX = -2
	end
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
	damage = 5,
	rotation = 0,
	isEnemy = false
}

function BasicShot.draw(this)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(BasicShot.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), this.rotation, BasicShot.scaleX, BasicShot.scaleY, 0, 0)
end

function BasicShot.behaivor(this)
	-- Figure out shot position
	if (this.rightShot == nil and this.rightUpShot == nil and this.leftUpShot == nil and this.leftShot == nil) then
		if (Heartbeat.player.forwardFace) then
			if (Heartbeat.player.isUp) then
				this.rightUpShot = true
			else
				this.rightShot = true
			end
		else
			if (Heartbeat.player.isUp) then
				this.leftUpShot = true
			else
				this.leftShot = true
			end
		end
	end
	-- Give it proper velocity
	if (this.rightShot) then
		this.dx = 12
	end
	if (this.leftShot) then
		this.dx = -12
		this.rotation = math.pi
	end
	if (this.rightUpShot or this.leftUpShot) then
		this.dy = -12
		this.rotation = math.pi * 1.5
	end
	for i=1,#Heartbeat.entities do
		if (Heartbeat.entities[i] == nil) then return end
		if (Heartbeat.entities[i].isEnemy and Heartbeat.checkEntityCollision(this, Heartbeat.entities[i])) then
			Heartbeat.updateEntityHealth(Heartbeat.entities[i], Heartbeat.entities[i].health - BasicShot.damage)
			Heartbeat.removeEntity(this)
		end
	end
	if (this.dx == 12 or this.dx == -12) then
		this.dy = -.5
	end
end

function BasicShot.onCollision(this, collidedObject)
	Heartbeat.removeEntity(this)
end

MatterShot = {
	id = "matter_shot",
	texture = love.graphics.newImage("assets/proton/shot/missile.png"),
	scaleX = 1.2,
	scaleY = 1.2,
	height = 16,
	width = 16,
	damage = 5,
	isEnemy = false
}

function MatterShot.draw(this)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(MatterShot.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, MatterShot.scaleX, MatterShot.scaleY, 0, 0)
end

function MatterShot.behaivor(this)
	if (Heartbeat.player.forwardFace) then
		if (this.dx ~= -15) then
			this.dx = 15
		end
	else
		if (this.dx ~= 15) then
			this.dx = -15
		end
	end
	for i=1,#Heartbeat.entities do
		if (Heartbeat.entities[i] == nil) then return end
		print(Heartbeat.entities[i].id)
		if (Heartbeat.entities[i].isEnemy and Heartbeat.checkEntityCollision(this, Heartbeat.entities[i])) then
			Heartbeat.updateEntityHealth(Heartbeat.entities[i], Heartbeat.entities[i].health - MatterShot.damage)
			Heartbeat.removeEntity(this)
		end
	end
	this.dy = -.5
end

function MatterShot.onCollision(this, collidedObject)
	Heartbeat.removeEntity(this)
	if (collidedObject.id == "door") then
		Heartbeat.removeTile(collidedObject)
	end
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
	health = 10,
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
	if (Heartbeat.checkEntityCollision(Heartbeat.player, this)) then
		Heartbeat.player.updateHealth(Heartbeat.player.health - 10)
	end
end

function Slime.onDeath(this)
	local dropChance = math.floor(math.random() * 9)
	if (dropChance == 7) then
		Heartbeat.newItem(HealthPickup, this.x, this.y)
	elseif (dropChance == 6) then
		Heartbeat.newItem(DarkPickup, this.x, this.y)
	end
end

Imp = {
	id = "imp",
	texture = love.graphics.newImage("assets/enemies/imp1.png"),
	frames = {
		love.graphics.newImage("assets/enemies/imp1.png"),
		love.graphics.newImage("assets/enemies/imp2.png"),
		love.graphics.newImage("assets/enemies/imp3.png"),
		love.graphics.newImage("assets/enemies/imp4.png"),
	},
	scaleX = 3,
	scaleY = 3,
	height = 24,
	width = 48,
	offsetX = 0,
	offsetY = 3,
	isEnemy = true,
	movementFrames = 0,
	noticedPlayer = false
}

function Imp.draw(this)
	this.movementFrames = this.movementFrames + 1
	if (this.movementFrames >= 40) then
		this.movementFrames = 0
	end
	this.texture = Imp.frames[1 + math.floor(this.movementFrames / 10)]
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(this.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, Imp.scaleX, Imp.scaleY, Imp.offsetX, Imp.offsetY)
end

function Imp.behaivor(this)
	this.dy = -.5
	if (math.abs(Heartbeat.player.x - this.x) < 200 and math.abs(Heartbeat.player.y - this.y) < 200) then
		this.noticedPlayer = true
	else
		this.noticedPlayer = false
	end
	if (this.noticedPlayer) then
		if (Heartbeat.player.x < this.x) then
			this.x = this.x - 3
		else
			this.x = this.x + 3
		end
		if (Heartbeat.player.y < this.y) then
			this.y = this.y - 1.5
		else
			this.y = this.y + 1.5
		end
	else
		this.x = this.x + math.cos(this.movementFrames)
		this.y = this.y + math.sin(this.movementFrames)
	end
end

