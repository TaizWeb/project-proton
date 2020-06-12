love.graphics.setDefaultFilter("nearest", "nearest")
require("lib/heartbeat")
require("tiles")
require("items")
require("entities")
require("player")

function love.load()
	windowWidth = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()
	love.window.setTitle("Project Proton")
	love.keyboard.setKeyRepeat(true)
	love.filesystem.setIdentity("project-proton")
	Heartbeat.createPlayer(Player, 200, 200)
	Heartbeat.tilesList = {BunkerTile, BunkerFloorExtended, BunkerWall, Cobble, Door, Screen, Pod, Corpse, LockedDoor, CobbleWeb, BunkerWeb, BunkerExtWeb, Bed, BloodyBed, Stalagtite, Pebble, Lift}
	Heartbeat.entitiesList = {Terminal, BasicShot, MatterShot, Slime, Imp, Pained, Frog, Tadpole, Specks, Widow, Spiderling, Scientist1, Scientist2, Mother, Elle}
	Heartbeat.itemsList = {DarkMatterUpgrade, HealthTankUpgrade, GrappelUpgrade, LongJumpUpgrade, GravityUpgrade, ChargeBeamUpgrade, TriBeamUpgrade, HealthPickup, DarkPickup}
	Heartbeat.dialog.speakers = {"Gray", "PROTON", "Montague", "Specks", "Elle"}
	Heartbeat.editor.readLevel("start")
	Heartbeat.setDimensions(windowWidth, windowHeight)
	-- Some godmode features
	Player.matter = 10
end

function love.keypressed(key, scancode, isrepeat)
	-- Activate editor
	if (key == "e" and not Heartbeat.editor.commandMode) then
		Heartbeat.editor.isActive = not Heartbeat.editor.isActive
	end
	-- Send keys to editor if active
	if (Heartbeat.editor.isActive) then
		Heartbeat.editor.handleInput(key)
	else
		-- Jump
		if (key == "z" and not Heartbeat.dialog.isOpen) then
			Heartbeat.jump(Heartbeat.player)
			Heartbeat.player.isCrouched = false
		end
		-- Interact/fire
		if (key == "x") then
			if (checkTerminalRange() or Heartbeat.levelName == "spider6") then
				Heartbeat.player.dx = 0
				if (Heartbeat.dialog.isOpen and Heartbeat.redText == nil) then
					Heartbeat.dialog.nextLine()
				else
					if (Heartbeat.levelName == "start") then
						Heartbeat.dialog.openDialog("start")
						Player.setNewObjective("Mission Objective: Locate Escape Pod")
						-- Open the door up
						for i=1,#Heartbeat.tiles do
							if (Heartbeat.tiles[i].id == "door") then
								table.remove(Heartbeat.tiles, i)
								break
							end
						end
					elseif (Heartbeat.levelName == "bunker4") then
						Heartbeat.dialog.openDialog("log2")
					elseif (Heartbeat.levelName == "cave4") then
						Heartbeat.dialog.openDialog("log3")
					elseif (Heartbeat.levelName == "cave8") then
						Heartbeat.dialog.openDialog("log4")
					elseif (Heartbeat.levelName == "spider4") then
						Heartbeat.dialog.openDialog("log5")
					elseif (Heartbeat.levelName == "spider8") then
						Heartbeat.dialog.openDialog("log6")
					elseif (Heartbeat.levelName == "spider10" and Heartbeat.redText == nil) then
						Heartbeat.dialog.openDialog("log7")
					end
				end
			else
				if (not Player.isUpsideDown) then
					if (love.keyboard.isDown("lshift")) then
						Player.shootMatter()
					else
						Player.shoot()
					end
				end
			end
		end
		if (key == "down") then
			Player.setCrouch()
		end
		if (key == "up") then
			Player.setUp()
		end
		if (key == "lctrl" and Player.hasGravityUpgrade) then
			Player.isUpsideDown = not Player.isUpsideDown
			print(Player.isUpsideDown)
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
			Heartbeat.player.isCrouched = false
			Heartbeat.player.isUp = false
		elseif (love.keyboard.isDown("right")) then
			Heartbeat.player.dx = 5
			Heartbeat.player.isCrouched = false
			Heartbeat.player.isUp = false
		else
			Heartbeat.player.dx = 0
		end
	end
	if (Heartbeat.editor.isActive) then
		if (love.mouse.isDown(1) and Heartbeat.editor.mode == "tile") then
			Heartbeat.editor.handleInput(1)
		end
		if (love.mouse.isDown(2)) then
			Heartbeat.editor.handleInput(2)
		end
	end
	if (Player.isUpsideDown) then
		Player.dy = -1
	end
	if (Player.displayObjective) then
		Player.objectiveCounter = Player.objectiveCounter + 1
	end
end

function love.draw()
	Heartbeat.beat()
	if (Player.displayObjective) then
		Player.drawObjective()
	end
end

