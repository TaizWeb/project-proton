require("lib/heartbeat")
love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
	windowWidth = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()
	love.window.setTitle("Project Proton")
	love.keyboard.setKeyRepeat(true)
	love.filesystem.setIdentity("project-proton")
	Heartbeat.createPlayer(Player, 100, 100)
	Heartbeat.tilesList = {BunkerTile}
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

BunkerTile = {
	id = "bunker",
	texture = love.graphics.newImage("assets/tiles/bunker-tileset.png"),
	height = 25,
	width = 25,
	offsetX = 0,
	offsetY = 0,
	scaleX = 25/16,
	scaleY = 25/15 
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
	height = 20,
	width = 20,
	isEnemy = false
}

HealthTankUpgrade = {
	id = "healthupgrade",
	height = 20,
	width = 20,
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
	height = 20,
	width = 20,
	isEnemy = false
}

GravityUpgrade = {
	id = "gravityupgrade",
	height = 20,
	width = 20,
	isEnemy = false
}

ChargeBeamUpgrade = {
	id = "chargeupgrade",
	height = 20,
	width = 20,
	isEnemy = false
}

TriBeamUpgrade = {
	id = "tribeamupgrade",
	height = 20,
	width = 20,
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
end

function love.draw()
	Heartbeat.beat()
end

