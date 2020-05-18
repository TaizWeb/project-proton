require("lib/heartbeat")
love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
	windowWidth = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()
	love.window.setTitle("Project Proton")
	love.keyboard.setKeyRepeat(true)
	love.filesystem.setIdentity("project-proton")
	Heartbeat.createPlayer(Player, 200, 200)
	Heartbeat.tilesList = {BunkerTile, BunkerWall, Screen, Pod, Corpse}
	Heartbeat.entitiesList = {Terminal}
	Heartbeat.itemsList = {DarkMatterUpgrade, HealthTankUpgrade, GrappelUpgrade, LongJumpUpgrade, GravityUpgrade, ChargeBeamUpgrade, TriBeamUpgrade}
	Heartbeat.dialog.speakers = {"Gray", "PROTON"}
	Heartbeat.editor.readLevel("start")
end

Player = {
	height = 60,
	width = 25,
	texture = love.graphics.newImage("assets/proton/proton-firing.png")
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

BunkerWall = {
	id = "bunker_wall",
	texture = love.graphics.newImage("assets/tiles/bunker-wallset.png"),
	height = 25,
	width = 25,
	scaleX = 25/16,
	scaleY = 25/16,
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

function HealthTankUpgrade.onPickup(this)
	print("Grabbed item upgrade")
	Heartbeat.removeItem(this)
end

function Player.draw(this)
	local scaleX = 2
	local scaleY = 2
	local offsetX = 10
	local offsetY = 2
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(Player.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, scaleX, scaleY, offsetX, offsetY)
end

function Terminal.draw(this)
	local scaleX = 2
	local scaleY = 2
	local offsetX = 10
	local offsetY = 13
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(Terminal.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, scaleX, scaleY, offsetX, offsetY)
end

function Player.shoot()
	print("pew pew")
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

