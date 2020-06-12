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
	if (Heartbeat.levelName == "cave4" or Heartbeat.levelName == "spider10") then
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
		if (not (Heartbeat.levelName == "spider5" and Player.flags.hasSeenSpecks)) then
			Heartbeat.removeTile(collidedObject)
		end
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
	health = 10,
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
	if (Heartbeat.checkEntityCollision(Heartbeat.player, this)) then
		Heartbeat.player.updateHealth(Heartbeat.player.health - 10)
	end
end

Frog = {
	id = "frog",
	texture = love.graphics.newImage("assets/enemies/frog1.png"),
	frames = {
		love.graphics.newImage("assets/enemies/frog1.png"),
		love.graphics.newImage("assets/enemies/frog2.png"),
		love.graphics.newImage("assets/enemies/frog3.png"),
		love.graphics.newImage("assets/enemies/frog4.png"),
	},
	scaleX = 3,
	scaleY = 3,
	height = 192,
	width = 150,
	offsetX = 0,
	offsetY = 3,
	isEnemy = true,
	movementFrames = 0,
	health = 200
}

Tadpole = {
	id = "tadpole",
	texture = love.graphics.newImage("assets/enemies/tadpole1.png"),
	frames = {
		love.graphics.newImage("assets/enemies/tadpole1.png"),
		love.graphics.newImage("assets/enemies/tadpole2.png")
	},
	scaleX = 3,
	scaleY = 3,
	offsetX = 0,
	offsetY = 9,
	width = 24,
	height = 20,
	isEnemy = true,
	health = 1,
	forwardFace = false
}

function Frog.draw(this)
	if (this.texture == nil) then
		this.texture = Frog.texture
	end
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(this.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, Frog.scaleX, Frog.scaleY, 12, 0)
end

function Frog.behaivor(this)
	if (math.ceil(math.random() * 180) == 1) then
		this.isAttacking = true
	end
	if (this.isAttacking ~= nil and this.isAttacking) then
		if (this.movementFrames >= 40) then
			this.isAttacking = false
			Heartbeat.newEntity(Tadpole, this.x - 10, this.y + 20)
			this.movementFrames = 0
		end
		this.movementFrames = this.movementFrames + 1
		this.texture = Frog.frames[math.ceil(this.movementFrames / 10)]
	end
end

function Frog.onDeath(this)
	-- Unlock the doors
	for i=1,#Heartbeat.tiles do
		if (Heartbeat.tiles[i] ~= nil) then
			if (Heartbeat.tiles[i].id == "lockeddoor") then
				Heartbeat.removeTile(Heartbeat.tiles[i])
			end
		end
	end
	-- Drop some pickups
	Heartbeat.newItem(HealthPickup, this.x - 50, this.y - 50)
	Heartbeat.newItem(HealthPickup, this.x - 10, this.y - 10)
	Heartbeat.newItem(HealthPickup, this.x - 30, this.y)
	Heartbeat.newItem(DarkPickup, this.x + 37, this.y - 20)
	Heartbeat.newItem(DarkPickup, this.x + 68, this.y - 24)
	Player.flags.hasKilledFrog = true
end

function Tadpole.draw(this)
	love.graphics.setColor(1, 1, 1, 1)
	if (not this.forwardFace) then
		this.scaleX = 3
		this.offsetX = 0
	else
		this.scaleX = -3
		this.offsetX = 10
	end
	love.graphics.draw(Tadpole.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, this.scaleX, Tadpole.scaleY, this.offsetX, Tadpole.offsetY)
end

function Tadpole.behaivor(this)
	if (Heartbeat.getTile(this.x + this.width + 5, this.y) ~= nil) then
		this.forwardFace = false
	elseif (Heartbeat.getTile(this.x - 5, this.y) ~= nil) then
		this.forwardFace = true
	end
	if (this.forwardFace) then
		this.dx = 5
	else
		this.dx = -5
	end
	if (Heartbeat.checkEntityCollision(Heartbeat.player, this)) then
		Heartbeat.player.updateHealth(Heartbeat.player.health - 10)
	end
end

Specks = {
	id = "specks",
	texture = love.graphics.newImage("assets/misc/specks.png"),
	frames = {},
	scaleX = 3,
	scaleY = 3,
	offsetX = 0,
	offsetY = 0,
	width = 27,
	height = 81,
	isEnemy = false,
	health = 11037,
	frameCounter = 0,
	forwardFace = true
}

function Specks.draw(this)
	this.texture = Specks.texture
	love.graphics.draw(this.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, Specks.scaleX, Specks.scaleY, this.offsetX, this.offsetY)
end

function Specks.behaivor(this)
	if (Specks.frameCounter < 30) then
		Heartbeat.player.dx = -5
		Specks.frameCounter = Specks.frameCounter + 1
	elseif (Specks.frameCounter == 30) then
		Heartbeat.dialog.openDialog("sci")
		Specks.frameCounter = Specks.frameCounter + 1
	elseif (Specks.frameCounter == 31 and not Heartbeat.dialog.isOpen) then
		Player.setNewObjective("Mission Objective: Find the Survivors")
		Heartbeat.player.dx = 5
		Player.flags.hasSeenSpecks = true
	end
end

Scientist1 = {
	id = "scientist1",
	texture = love.graphics.newImage("assets/misc/scientist1.png"),
	frames = {},
	scaleX = 3,
	scaleY = 3,
	offsetX = 0,
	offsetY = 0,
	width = 27,
	height = 81,
	isEnemy = false,
	health = 11037,
	frameCounter = 0,
	forwardFace = true
}

Scientist2 = {
	id = "scientist2",
	texture = love.graphics.newImage("assets/misc/scientist2.png"),
	frames = {},
	scaleX = 3,
	scaleY = 3,
	offsetX = 0,
	offsetY = 0,
	width = 27,
	height = 81,
	isEnemy = false,
	health = 11037,
	frameCounter = 0,
	forwardFace = true
}

Mother = {
	id = "mother",
	texture = love.graphics.newImage("assets/misc/mother.png"),
	frames = {},
	scaleX = 3,
	scaleY = 3,
	offsetX = 0,
	offsetY = 0,
	width = 27,
	height = 81,
	isEnemy = false,
	health = 11037,
	frameCounter = 0,
	forwardFace = true
}

Elle = {
	id = "elle",
	texture = love.graphics.newImage("assets/misc/elle.png"),
	frames = {},
	scaleX = 3,
	scaleY = 3,
	offsetX = 0,
	offsetY = 0,
	width = 14 * 2,
	height = 28 * 2,
	isEnemy = false,
	health = 11037,
	frameCounter = 0,
	forwardFace = true
}

function Scientist1.draw(this)
	local scaleX = 3
	local scaleY = 3
	if (this.texture == Elle.texture) then
		scaleX = 2
		scaleY = 2
	end

	love.graphics.draw(this.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, scaleX, scaleY, this.offsetX, this.offsetY)
end

Scientist2.draw = Scientist1.draw
Mother.draw = Scientist1.draw
Elle.draw = Scientist1.draw

Widow = {
	id = "widow",
	texture = love.graphics.newImage("assets/enemies/widow1.png"),
	frames = {
		love.graphics.newImage("assets/enemies/widow1.png"),
		love.graphics.newImage("assets/enemies/widow2.png"),
		love.graphics.newImage("assets/enemies/widow3.png"),
		love.graphics.newImage("assets/enemies/widow4.png"),
	},
	butt = {
		love.graphics.newImage("assets/enemies/spider-butt1.png"),
		love.graphics.newImage("assets/enemies/spider-butt2.png"),
		love.graphics.newImage("assets/enemies/spider-butt3.png"),
		love.graphics.newImage("assets/enemies/spider-butt4.png"),
		love.graphics.newImage("assets/enemies/spider-butt5.png"),
		love.graphics.newImage("assets/enemies/spider-butt6.png"),
	},
	scaleX = 5,
	scaleY = 5,
	height = 23 * 5,
	width = 53 * 5,
	rotation = 0,
	offsetX = 0,
	offsetY = 0,
	isEnemy = true,
	moveLeft = true,
	health = 400,
	movementFrames = 0
}

function Widow.draw(this)
	this.movementFrames = this.movementFrames + 1
	if (not this.isHanging) then
		if (this.movementFrames >= 40) then
			this.movementFrames = 0
		end
		this.texture = Widow.frames[1 + math.floor(this.movementFrames / 10)]
	else
		-- Laying
		if (this.movementFrames >= 60) then
			this.movementFrames = 0
			this.hasLaid = false
		end
		this.texture = Widow.butt[1 + math.floor(this.movementFrames / 10)]
		if (this.texture == Widow.butt[6] and not this.hasLaid) then
			Widow.lay(this)
			this.hasLaid = true
		end
	end
	-- Draw
	love.graphics.setColor(1, 1, 1, 1)
	--love.graphics.rectangle("fill", Camera.convert("x", this.x), Camera.convert("y", this.y), this.width, this.height)
	love.graphics.draw(this.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), this.rotation, Widow.scaleX, Widow.scaleY, this.offsetX, this.offsetY)
end

function Widow.behaivor(this)
	-- Have the spider climb up walls
	if (Heartbeat.getTile(this.x - 4, this.y) ~= nil and not this.isClimbing) then
		this.rotation = math.pi/2
		-- A very clever way to swap two variables without using a temp
		this.width = this.width + this.height
		this.height = this.width - this.height
		this.width = this.width - this.height
		this.y = this.y - 200
		this.offsetY = 23
		this.isClimbing = true
	end
	if (this.isClimbing) then
		this.dy = -4
	elseif (not this.isHanging) then
		this.dx = -4
	end
	-- Egg laying
	if ((this.y + this.height) < 0 and not this.isHanging) then
		this.isClimbing = false
		this.isHanging = true
		this.width = 25 * 5
		this.height = 22 * 5
		this.x = 300
		this.y = 0
		this.offsetY = 0
		this.rotation = 0
		this.texture = Widow.butt[1]
	end
	-- Stop it from obeying gravity when hanging
	if (this.isHanging) then
		this.dy = -.5
		this.dx = 0
	end
	-- Collision
	if (Heartbeat.checkEntityCollision(Heartbeat.player, this)) then
		Heartbeat.player.updateHealth(Heartbeat.player.health - 20)
	end
end

function Widow.onDeath(this)
	-- Unlock the doors
	for i=1,#Heartbeat.tiles do
		if (Heartbeat.tiles[i] ~= nil) then
			if (Heartbeat.tiles[i].id == "lockeddoor") then
				Heartbeat.removeTile(Heartbeat.tiles[i])
			end
		end
	end
	-- Drop some pickups
	Heartbeat.newItem(HealthPickup, this.x - 50, this.y - 50)
	Heartbeat.newItem(HealthPickup, this.x - 10, this.y - 10)
	Heartbeat.newItem(HealthPickup, this.x - 30, this.y)
	Heartbeat.newItem(DarkPickup, this.x + 37, this.y - 20)
	Heartbeat.newItem(DarkPickup, this.x + 68, this.y - 24)
	Heartbeat.newItem(GravityUpgrade, Heartbeat.player.x + 50, Heartbeat.player.y + Heartbeat.player.width - 20)
	Player.flags.hasKilledWidow = true
end

function Widow.lay(this)
	if (this.layCount == nil) then
		this.layCount = 0
	end
	Heartbeat.newEntity(Spiderling, this.x + (this.width / 2), this.y + this.height)
	this.layCount = this.layCount + 1
	if (this.layCount >= 3) then
		this.height = 23 * 5
		this.width = 53 * 5
		this.layCount = 0
		this.isHanging = false
	end
end

Spiderling = {
	id = "spiderling",
	texture = love.graphics.newImage("assets/enemies/spiderling1.png"),
	frames = {
		love.graphics.newImage("assets/enemies/spiderling1.png"),
		love.graphics.newImage("assets/enemies/spiderling2.png"),
	},
	scaleX = 3,
	scaleY = 3,
	height = 7 * 3,
	width = 21 * 3,
	offsetX = 0,
	offsetY = 0,
	isEnemy = true,
	moveLeft = true,
	health = 10,
	movementFrames = 0
}

function Spiderling.draw(this)
	-- Making them flip around
	if (not this.forwardFace) then
		this.scaleX = 3
		this.offsetX = 0
	else
		this.scaleX = -3
		this.offsetX = 21
	end
	-- Animation
	this.movementFrames = this.movementFrames + 1
	if (this.movementFrames >= 20) then
		this.movementFrames = 0
	end
	this.texture = Spiderling.frames[1 + math.floor(this.movementFrames / 10)]
	love.graphics.setColor(1, 1, 1, 1)
	--love.graphics.rectangle("fill", Camera.convert("x", this.x), Camera.convert("y", this.y), this.width, this.height)
	love.graphics.draw(this.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, this.scaleX, Spiderling.scaleY, this.offsetX, Spiderling.offsetY)
end

Spiderling.behaivor = Tadpole.behaivor
