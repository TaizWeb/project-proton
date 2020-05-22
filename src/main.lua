require("lib/heartbeat")
require("tiles")
require("items")
require("entities")
require("player")
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
	Heartbeat.dialog.speakers = {"Gray", "PROTON", "Montague"}
	Heartbeat.editor.readLevel("start")
	Heartbeat.setDimensions(windowWidth, windowHeight)
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
					if (Heartbeat.levelName == "start") then
						Heartbeat.dialog.openDialog("start")
						for i=1,#Heartbeat.tiles do
							if (Heartbeat.tiles[i].id == "door") then
								table.remove(Heartbeat.tiles, i)
								break
							end
						end
					elseif (Heartbeat.levelName == "bunker4") then
						Heartbeat.dialog.openDialog("log2")
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

