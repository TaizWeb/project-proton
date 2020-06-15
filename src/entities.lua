require("lib/standard")

function genericDrop(this)
	local dropChance = math.floor(math.random() * 9)
	if (dropChance == 7) then
		Heartbeat.newItem(HealthPickup, this.x, this.y)
	elseif (dropChance == 6) then
		Heartbeat.newItem(DarkPickup, this.x, this.y)
	end
end

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
	if (Heartbeat.levelName == "cave4" or Heartbeat.levelName == "spider10" or Heartbeat.levelName == "spider13") then
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
	bluetexture = love.graphics.newImage("assets/proton/shot/blueshot.png"),
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

ZeroShot = {
	id = "zero_shot",
	texture = love.graphics.newImage("assets/misc/zeroshot1.png"),
	frames = {
		love.graphics.newImage("assets/misc/zeroshot1.png"),
		love.graphics.newImage("assets/misc/zeroshot2.png"),
		love.graphics.newImage("assets/misc/zeroshot3.png"),
		love.graphics.newImage("assets/misc/zeroshot4.png"),
	},
	scaleX = 1.2,
	scaleY = 1.2,
	height = 32,
	width = 32,
	damage = 5,
	rotation = 0,
	isEnemy = false
}

function ZeroShot.behaivor(this)
	local zeroX = 0
	local zeroY = 0
	if (this.initialX == nil) then
		this.initialX = this.x
		this.initialY = this.y
	end
	if (this.radians == nil) then
		this.radians = 0
	end
	for i=1,#Heartbeat.entities do
		if (Heartbeat.entities[i].id == "zero") then
			zeroX = Heartbeat.entities[i].x
			zeroY = Heartbeat.entities[i].y
		end
	end
	this.x = zeroX + (50 * math.cos(this.radians))
	this.y = zeroY + (50 * math.sin(this.radians))
	this.radians = this.radians + .1
	-- Update health on hit
	if (Heartbeat.checkEntityCollision(this, Heartbeat.player)) then
		Heartbeat.player.updateHealth(Heartbeat.player.health - 20)
	end
end

function ZeroShot.draw(this)
	love.graphics.setColor(1, 1, 1, 1)
	--love.graphics.rectangle("fill", Camera.convert("x", this.x), Camera.convert("y", this.y), this.width, this.height)
	love.graphics.draw(ZeroShot.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, MatterShot.scaleX, MatterShot.scaleY, 0, 0)
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
	genericDrop(this)
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

function Imp.onDeath(this)
	genericDrop(this)
end

Egg = {
	id = "egg",
	texture = love.graphics.newImage("assets/enemies/egg1.png"),
	frames = {
		love.graphics.newImage("assets/enemies/egg1.png"),
		love.graphics.newImage("assets/enemies/egg2.png"),
		love.graphics.newImage("assets/enemies/egg3.png"),
		love.graphics.newImage("assets/enemies/egg4.png"),
		love.graphics.newImage("assets/enemies/egg5.png"),
		love.graphics.newImage("assets/enemies/egg6.png"),
		love.graphics.newImage("assets/enemies/egg7.png"),
	},
	scaleX = 3,
	scaleY = 3,
	height = 30,
	width = 45,
	health = 10,
	offsetX = 0,
	offsetY = 0,
	isEnemy = true,
	movementFrames = 0,
	noticedPlayer = false
}

Hatchling = {
	id = "hatchling",
	texture = love.graphics.newImage("assets/enemies/hatchling1.png"),
	frames = {
		love.graphics.newImage("assets/enemies/hatchling1.png"),
		love.graphics.newImage("assets/enemies/hatchling2.png"),
		love.graphics.newImage("assets/enemies/hatchling3.png"),
	},
	scaleX = 3,
	scaleY = 3,
	height = 45,
	width = 33,
	health = 20,
	offsetX = 0,
	offsetY = 0,
	isEnemy = true,
	movementFrames = 0
}

function Egg.draw(this)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(this.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, Egg.scaleX, Egg.scaleY, Egg.offsetX, Egg.offsetY)
end

function Hatchling.draw(this)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(this.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, this.scaleX, Hatchling.scaleY, this.offsetX, Hatchling.offsetY)
end

function Egg.behaivor(this)
	if (this.frameCounter == nil) then
		this.frameCounter = 0
	end
	if (math.abs(this.x - Heartbeat.player.x) < 100) then
		if (this.frameCounter == 0) then
			this.frameCounter = 30
		end
	end
	if (this.frameCounter > 0) then
		if (this.frameCounter == 25) then
			this.texture = Egg.frames[2]
		elseif (this.frameCounter == 20) then
			this.texture = Egg.frames[3]
		elseif (this.frameCounter ==15) then
			this.texture = Egg.frames[4]
		elseif (this.frameCounter == 10) then
			this.texture = Egg.frames[5]
		elseif (this.frameCounter == 5) then
			this.texture = Egg.frames[6]
		elseif (this.frameCounter == 1) then
			this.texture = Egg.frames[7]
			Heartbeat.newEntity(Hatchling, this.x, this.y - 20)
			Heartbeat.removeEntity(this)
		end
		this.frameCounter = this.frameCounter - 1
	end
end

function Hatchling.behaivor(this)
	if (this.movementFrames <= 0) then
		this.movementFrames = 30
	end
	if ((this.x - Heartbeat.player.x) > 0) then
		this.moveLeft = false
		this.scaleX = 3
	else
		this.moveLeft = true
		this.scaleX = -3
	end
	if (this.moveLeft) then
		this.dx = 3
	else
		this.dx = -3
	end
	this.texture = Hatchling.frames[math.ceil(this.movementFrames / 10)]
	this.movementFrames = this.movementFrames - 1
	if (Heartbeat.checkEntityCollision(this, Heartbeat.player)) then
		Heartbeat.player.updateHealth(Heartbeat.player.health - 10)
	end
end

function Hatchling.onDeath(this)
	genericDrop(this)
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

function Elle.behaivor()
	if (Player.flags.hasSeenMemory == nil) then
		Heartbeat.clear()
		Heartbeat.player.x = 1000
		Heartbeat.player.y = 1000
		Heartbeat.dialog.openDialog("memory", reloadEnd)
		Player.flags.hasSeenMemory = true
		Elle.frames = 420
	end
	if (Player.flags.hasObjective) then
		-- Movement speeds
		if (Elle.frames > 300) then
			Heartbeat.player.dx = 3
		elseif (Elle.frames > 180) then
			Heartbeat.player.dx = 2
		elseif (Elle.frames > 60) then
			Heartbeat.player.dx = 1
		elseif (Elle.frames == 0) then
			Heartbeat.player.dx = 0
		elseif (Elle.frames < -120 and not Heartbeat.dialog.isOpen) then
			Heartbeat.player.dx = -5
		end
		-- Objective setters
		if (Elle.frames == 240) then
			Player.setNewObjective("Escape the facility")
		end
		if (Elle.frames == 180) then
			Player.setNewObjective("Esca e the facl ty")
		end
		if (Elle.frames == 120) then
			Player.setNewObjective("Escae faclty")
		end
		if (Elle.frames == 60) then
			Player.setNewObjective("GET OUT")
		end
		if (Elle.frames == -120) then
			Player.setNewObjective("Mission Objective: B E   H U M A N")
			Heartbeat.dialog.openDialog("behuman")
		end
		Elle.frames = Elle.frames - 1
	end
end

function reloadEnd()
	Heartbeat.editor.readLevel("end")
	Heartbeat.player.dy = 0
	Heartbeat.player.x = 30
	Heartbeat.player.y = 390
	print("ATTEMPTING TO SET AFTERFUNC")
	Heartbeat.dialog.openDialog("end", leaveThem)
end

function leaveThem()
	Player.setNewObjective("Mission Objective: Escape the facility")
	Player.flags.hasObjective = true
end

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

Zero = {
	id = "zero",
	texture = love.graphics.newImage("assets/misc/zero.png"),
	shot = love.graphics.newImage("assets/misc/zeroshot.png"),
	frames = {},
	frameCounter = 120,
	scaleX = 3,
	scaleY = 3,
	width = 9 * 3,
	height = 27 * 3,
	isEnemy = true,
	health = 66,
	forwardFace = true,
	opacity = 0,
	event = false,
	grabbedPlayer = false,
	isButtMad = false,
	spawnedShot = false
}

function Zero.draw(this)
	--this.opacity = 1
	--Player.flags.hasObjective = true
	--Zero.event = true
	if (Player.flags.hasObjective or Zero.event or Zero.isButtMad) then
		this.opacity = 1
		Player.flags.hasObjective = false
		Heartbeat.newTile(LockedDoor, 975, 375)
		Heartbeat.newTile(LockedDoor, 0, 375)
	else
		this.opacity = 0
	end
	love.graphics.setColor(1, 1, 1, this.opacity)
	love.graphics.draw(this.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, Zero.scaleX, Zero.scaleY, this.offsetX, this.offsetY)
end

function Zero.behaivor(this)
	if (this.opacity == 1 and not Zero.event and not Zero.isButtMad) then
		Heartbeat.dialog.openDialog("zero")
		Zero.event = true
	end
	if (not Heartbeat.dialog.isOpen and not Zero.isButtMad and Zero.event) then
		this.dx = 5
	end
	if ((Heartbeat.checkEntityCollision(this, Heartbeat.player) or Zero.grabbedPlayer) and Zero.event) then
		Zero.grabbedPlayer = true
		this.x = 922
		--print("GOTCHA")
		-- These are being set every frame?? Yep. I have two days left, sue me.
		this.offsetX = 10
		Zero.scaleX = 2.5
		Zero.scaleY = 2.5
		if (Zero.frameCounter == 120) then
			this.texture = Player.smash[1]
		elseif (Zero.frameCounter == 110) then
			this.texture = Player.smash[2]
		elseif (Zero.frameCounter == 100) then
			this.texture = Player.smash[3]
		elseif (Zero.frameCounter == 90) then
			this.texture = Player.smash[4]
		elseif (Zero.frameCounter == 80) then
			this.texture = Player.smash[5]
		elseif (Zero.frameCounter == 50) then
			this.texture = Player.smash[4]
		elseif (Zero.frameCounter == 40) then
			this.texture = Player.smash[5]
		elseif (Zero.frameCounter == 10) then
			this.texture = Player.smash[4]
		elseif (Zero.frameCounter == 0) then
			this.texture = Player.smash[5]
		elseif (Zero.frameCounter == -30) then
			this.texture = Player.smash[4]
		elseif (Zero.frameCounter == -40) then
			this.texture = Player.smash[6]
		elseif (Zero.frameCounter == -50) then
			this.texture = Player.smash[7]
		elseif (Zero.frameCounter == -60) then
			this.texture = Player.smash[8]
		elseif (Zero.frameCounter == -80) then
			Heartbeat.clear()
			-- Hide the player off-screen
			Heartbeat.player.x = 1200
			Heartbeat.dialog.openDialog("break", wakeUp)
			Zero.grabbedPlayer = false
		end
		--print(Zero.frameCounter)
		Zero.frameCounter = Zero.frameCounter - 1
	end
	if (Zero.isButtMad and not Zero.spawnedShot and not Heartbeat.dialog.isOpen) then
		Zero.event = false
		this.dy = -10
		Heartbeat.newEntity(ZeroShot, this.x+10, this.y+10)
		Zero.spawnedShot = true
		this.moveLeft = true
	end
	if (Zero.isButtMad) then
		this.opacity = 1
		-- Checking if he's near the wall
		if (this.x < 200) then
			this.moveLeft = true
		elseif (this.x > 800) then
			this.moveLeft = false
		end
		-- Movement code
		if (this.moveLeft) then
			this.dx = 5
		else
			this.dx = -5
		end
	end
	if (this.dy > -.5) then
		this.dy = -.5
	end
end

ZeroDefeated = {
	id = "zero_defeated",
	texture = love.graphics.newImage("assets/misc/zero.png"),
	scaleX = 3,
	scaleY = 3,
	width = 9 * 3,
	height = 27 * 3,
}

function ZeroDefeated.draw(this)
	if (Heartbeat.dialog.isOpen) then
		love.graphics.setColor(1, 1, 1, 1)
	else
		love.graphics.setColor(1, 1, 1, 0)
	end
	love.graphics.draw(ZeroDefeated.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, ZeroDefeated.scaleX, ZeroDefeated.scaleY, ZeroDefeated.offsetX, ZeroDefeated.offsetY)
end

function Zero.onDeath(this)
	Heartbeat.newEntity(ZeroDefeated, Heartbeat.player.x - 50, Heartbeat.player.y)
	Heartbeat.dialog.openDialog("defeat", limitbreak)
end

function wakeUp()
	-- TODO: Add the dy fix to heartbeat
	Heartbeat.player.dy = 0
	Heartbeat.player.forwardFace = false
	Heartbeat.gotoRoom("spider14", 720, 390)
	Heartbeat.dialog.openDialog("zerospeech", blowItOutYourAss)
end

function blowItOutYourAss()
	BasicShot.texture = BasicShot.bluetexture
	Heartbeat.newEntity(BasicShot, Heartbeat.player.x, Heartbeat.player.y)
	Heartbeat.dialog.openDialog("blowitoutyourass")
	Heartbeat.dialog.afterFunc = nil
	Zero.isButtMad = true
end

function limitbreak()
	Heartbeat.newEntity(Imp, 50, 200)
	Heartbeat.newEntity(Imp, 100, 150)
	Heartbeat.newEntity(Imp, 200, 200)
	Heartbeat.newEntity(Imp, 123, 255)
	Heartbeat.newEntity(Imp, 280, 300)
	Heartbeat.dialog.openDialog("missioncomplete", detonate)
	Heartbeat.player.health = 99999
end

function detonate()
	whiteOut = true
	Heartbeat.player.x = 1400
end

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
	if (Player.flags.hasKilledWidow) then
		Heartbeat.removeEntity(this)
		for i=1,#Heartbeat.tiles do
			if (Heartbeat.tiles[i] ~= nil) then
				if (Heartbeat.tiles[i].id == "lockeddoor") then
					Heartbeat.removeTile(Heartbeat.tiles[i])
				end
			end
		end
	end
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
	Heartbeat.newItem(GravityUpgrade, Heartbeat.player.x + 50, Heartbeat.player.y - 20)
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
