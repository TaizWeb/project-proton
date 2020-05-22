require("lib/heartbeat")
love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
	windowWidth = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()
	love.window.setTitle("Project Proton")
	love.keyboard.setKeyRepeat(true)
	love.filesystem.setIdentity("project-proton")
	Heartbeat.createPlayer(Player, 200, 200)
	Heartbeat.tilesList = {BunkerTile, BunkerFloorExtended, BunkerWall, Door, Screen, Pod, Corpse}
	Heartbeat.entitiesList = {Terminal, BasicShot}
	Heartbeat.itemsList = {DarkMatterUpgrade, HealthTankUpgrade, GrappelUpgrade, LongJumpUpgrade, GravityUpgrade, ChargeBeamUpgrade, TriBeamUpgrade}
	Heartbeat.dialog.speakers = {"Gray", "PROTON"}
	Heartbeat.editor.readLevel("start")
	Heartbeat.setDimensions(windowWidth, windowHeight)
end

Player = {
	height = 60,
	width = 25,
	texture = love.graphics.newImage("assets/proton/proton-firing.png"),
	idle = love.graphics.newImage("assets/proton/proton-firing.png"),
	walk = {
		love.graphics.newImage("assets/proton/walk/proton-walk1.png"),
		love.graphics.newImage("assets/proton/walk/proton-walk2.png"),
		love.graphics.newImage("assets/proton/walk/proton-walk3.png"),
		love.graphics.newImage("assets/proton/walk/proton-walk4.png"),
		love.graphics.newImage("assets/proton/walk/proton-walk5.png"),
		love.graphics.newImage("assets/proton/walk/proton-walk6.png"),
	}
}

Screen = {
	id = "screen",
	texture = love.graphics.newImage("assets/misc/screen.png"),
	height = 13,
	width = 24,
	offsetX = 0,
	offsetY = 0,
	scaleX = 2,
	scaleY = 2,
	isSolid = false
}

Pod = {
	id = "pod",
	texture = love.graphics.newImage("assets/misc/pod.png"),
	height = 47,
	width = 28,
	offsetX = 0,
	offsetY = -3,
	scaleX = 3,
	scaleY = 3,
	isSolid = false
}

Corpse = {
	id = "corpse",
	texture = love.graphics.newImage("assets/misc/corpse.png"),
	height = 6,
	width = 32,
	offsetX = 0,
	offsetY = -3,
	scaleX = 3,
	scaleY = 3,
	isSolid = false
}

BunkerTile = {
	id = "bunker",
	texture = love.graphics.newImage("assets/tiles/bunker-tileset.png"),
	height = 25,
	width = 25,
	offsetX = 0,
	offsetY = 0,
	scaleX = 25/16,
	scaleY = 25/16,
	isSolid = true
}

BunkerFloorExtended = {
	id = "bunker_floor_ext",
	texture = love.graphics.newImage("assets/tiles/bunker-floor-extended.png"),
	height = 25,
	width = 25,
	offsetX = 0,
	offsetY = 0,
	scaleX = 25/16,
	scaleY = 25/16,
	isSolid = true
}

BunkerWall = {
	id = "bunker_wall",
	texture = love.graphics.newImage("assets/tiles/bunker-wallset.png"),
	height = 25,
	width = 25,
	scaleX = 25/16,
	scaleY = 25/16,
	isSolid = true
}

Door = {
	id = "door",
	texture = love.graphics.newImage("assets/tiles/door.png"),
	height = 75,
	width = 25,
	isSolid = true
}

Terminal = {
	id = "terminal",
	texture = love.graphics.newImage("assets/misc/terminal.png"),
	height = 70,
	width = 40,
	isEnemy = false
}

DarkMatterUpgrade = {
	id = "matterupgrade",
	texture = love.graphics.newImage("assets/items/darkmatter.png"),
	height = 20,
	width = 20,
	scaleX = 1.5,
	scaleY = 1.5,
	isEnemy = false
}

HealthTankUpgrade = {
	id = "healthupgrade",
	texture = love.graphics.newImage("assets/items/healthtank.png"),
	height = 20,
	width = 20,
	scaleX = 1.5,
	scaleY = 1.5,
	isEnemy = false
}

GrappelUpgrade = {
	id = "grappleupgrade",
	height = 20,
	width = 20,
	isEnemy = false
}

LongJumpUpgrade = {
	id = "jumpupgrade",
	texture = love.graphics.newImage("assets/items/longjump.png"),
	height = 20,
	width = 20,
	scaleX = 1.5,
	scaleY = 1.5,
	isEnemy = false
}

GravityUpgrade = {
	id = "gravityupgrade",
	texture = love.graphics.newImage("assets/items/gravity.png"),
	height = 20,
	width = 20,
	scaleX = 1.5,
	scaleY = 1.5,
	isEnemy = false
}

ChargeBeamUpgrade = {
	id = "chargeupgrade",
	texture = love.graphics.newImage("assets/items/charge.png"),
	height = 20,
	width = 20,
	scaleX = 1.5,
	scaleY = 1.5,
	isEnemy = false
}

TriBeamUpgrade = {
	id = "tribeamupgrade",
	texture = love.graphics.newImage("assets/items/tribeam.png"),
	height = 20,
	width = 20,
	scaleX = 1.5,
	scaleY = 1.5,
	isEnemy = false
}

BasicShot = {
	id = "basic_shot",
	texture = love.graphics.newImage("assets/proton/shot/shot1.png"),
	--frames = {
		--love.graphics.newImage("assets/proton/shot/shot1.png"),
		--love.graphics.newImage("assets/proton/shot/shot2.png"),
		--love.graphics.newImage("assets/proton/shot/shot3.png"),
		--love.graphics.newImage("assets/proton/shot/shot4.png"),
		--love.graphics.newImage("assets/proton/shot/shot5.png"),
		--love.graphics.newImage("assets/proton/shot/shot6.png"),
	--},
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

function HealthTankUpgrade.onPickup(this)
	print("Grabbed item upgrade")
	Heartbeat.removeItem(this)
end

function Player.draw(this)
	local scaleX = 2
	local scaleY = 2
	local offsetX = 10
	local offsetY = 2
	-- Determine which way the player faces
	if (Heartbeat.player.dx < 0) then
		Heartbeat.player.forwardFace = false
		Heartbeat.player.isWalking = true
	elseif (Heartbeat.player.dx > 0) then
		Heartbeat.player.forwardFace = true
		Heartbeat.player.isWalking = true
	else
		Heartbeat.player.isWalking = false
		Heartbeat.player.walkFrames = 0
		Player.texture = Player.idle
	end
	if (not Heartbeat.player.forwardFace) then
		scaleX = -2
		offsetX = 22
	end
	-- Walk animation
	if (Heartbeat.player.isWalking) then
		Heartbeat.player.walkFrames = Heartbeat.player.walkFrames + 2
		if (Heartbeat.player.walkFrames >= 60) then
			Heartbeat.player.walkFrames = 0
		end
		Player.texture = Player.walk[1 + math.floor(Heartbeat.player.walkFrames / 10)]
	end
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(Player.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, scaleX, scaleY, offsetX, offsetY)
end

function Player.shoot()
	Heartbeat.newEntity(BasicShot, Heartbeat.player.x+20, Heartbeat.player.y+5)
end

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

function love.keypressed(key, scancode, isrepeat)
	if (key == "e" and not Heartbeat.editor.commandMode) then
		Heartbeat.editor.isActive = not Heartbeat.editor.isActive
	end
	if (Heartbeat.editor.isActive) then
		Heartbeat.editor.handleInput(key)
	else
		if (key == "z" and not Heartbeat.dialog.isOpen) then
			Heartbeat.jump(Heartbeat.player)
		end
		if (key == "x") then
			if (checkTerminalRange()) then
				Heartbeat.player.dx = 0
				if (Heartbeat.dialog.isOpen) then
					Heartbeat.dialog.nextLine()
				else
					Heartbeat.dialog.openDialog("start")
					for i=1,#Heartbeat.tiles do
						if (Heartbeat.tiles[i].id == "door") then
							table.remove(Heartbeat.tiles, i)
							break
						end
					end
				end
			else
				Player.shoot()
			end
		end
	end
end

function love.mousepressed(x, y, button, istouch, presses)
	if (Heartbeat.editor.isActive) then
		Heartbeat.editor.handleInput(button)
	end
end

function love.update(dt)
	if (not Heartbeat.editor.isActive and not Heartbeat.dialog.isOpen) then
		if (love.keyboard.isDown("left")) then
			Heartbeat.player.dx = -5
		elseif (love.keyboard.isDown("right")) then
			Heartbeat.player.dx = 5
		else
			Heartbeat.player.dx = 0
		end
	end
	if (Heartbeat.editor.isActive) then
		if (love.mouse.isDown(1)) then
			Heartbeat.editor.handleInput(1)
		end
		if (love.mouse.isDown(2)) then
			Heartbeat.editor.handleInput(2)
		end
	end
end

function love.draw()
	Heartbeat.beat()
end

