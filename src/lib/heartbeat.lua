require("lib/camera")
require("lib/split")

-- TODO: Add a thing in heartbeat's init to create the levels folder if it doesn't exist
Heartbeat = {
	-- The gravitational constant, can be overridden for individual things by setting their own gravity parameter
	gravity = .5,
	-- Editor code
	editor = {
		isActive = false,
		mode = "tile",
		currentTile = 1,--"bunker",
		currentEntity = 1,--"terminal",
		currentItem = 1,--"jumpupgrade",
		commandModeLine = ""
	},
	dialog = {
		isOpen = false,
		font = love.graphics.newFont(20),
		speaker = nil,
		portrait = nil,
		dialogLines = {},
		dialogIndex = 0,
		-- What appears in the text box
		printedLines = {},
		dialogCharacter = 0,
		currentLine = "",
		speakers = {},
		portraits = {}
	},
	levelWidth = 0,
	levelHeight = 0,
	-- These will be set manually on startup
	tilesList = {},
	entitesList = {},
	itemsList = {},
	rooms = {},
	-- The currently loaded objects
	entities = {},
	tiles = {},
	items = {},
	player = {}
}

-- draw: Accepts two parameters, the object, and an optional texture. Without a texture the hitbox will be drawn.
function Heartbeat.draw(object)
	love.graphics.setColor(1, 1, 1, 1)
	if (object.texture ~= nil) then
		love.graphics.draw(object.texture, Camera.convert("x", object.x), Camera.convert("y", object.y), object.rotation, object.scaleX, object.scaleY, object.offsetX, object.offsetY)
	else
		love.graphics.rectangle("fill", Camera.convert("x", object.x), Camera.convert("y", object.y), object.width, object.height)
	end
end

-- createPlayer: Creates the player object and loads it into Heartbeat
function Heartbeat.createPlayer(object, x, y)
	Heartbeat.player.x = x
	Heartbeat.player.y = y
	Heartbeat.player.dx = 0
	Heartbeat.player.dy = 0
	Heartbeat.player.height = object.height
	Heartbeat.player.width = object.width
	Heartbeat.player.health = object.health
	Heartbeat.player.attack = object.attack
	Heartbeat.player.jumpFrames = 0
	Heartbeat.player.jumpCooldown = 0
	Heartbeat.player.inventory = {}
end

-- drawPlayer: Draws the player to the screen
function Heartbeat.drawPlayer()
	if (Player.draw ~= nil) then
		--Heartbeat.draw(Heartbeat.player)
		Player.draw(Heartbeat.player)
	else
		Heartbeat.draw(Heartbeat.player)
	end
end

-- doPlayer: Updates the player's dy/dx and moves them
function Heartbeat.doPlayer()
	Heartbeat.player.dy = Heartbeat.player.dy + Heartbeat.gravity
	Heartbeat.checkCollisions(Heartbeat.player)
	for i=1,#Heartbeat.items do
		if (Heartbeat.checkEntityCollision(Heartbeat.items[i], Heartbeat.player)) then
			local item = Heartbeat.items[i]
			if (item.onPickup ~= nil) then
				item.onPickup(item)
			end
		end
	end
end

function Heartbeat.jump(entity)
	if (not entity.isFalling) then
		entity.dy = -10
		entity.isFalling = true
	end
end

-- newEntity: Initializes and loads the entity into Heartbeat
function Heartbeat.newEntity(object, x, y)
	Heartbeat.entities[#Heartbeat.entities+1] = {
		id = object.id,
		x = x,
		y = y,
		originalX = object.x,
		originalY = object.y,
		dx = 0,
		dy = 0,
		width = object.width,
		height = object.height,
		health = object.health,
		attack = object.attack,
		behaivor = object.behaivor,
		onCollision = object.onCollision,
		draw = object.draw
	}
	if (object.isNPC) then
		Heartbeat.entities[#Heartbeat.entities].isNPC = true
	end
end

-- drawEntities: Draws all the entities to the screen
function Heartbeat.drawEntities()
	for i=1,#Heartbeat.entities do
		if (Heartbeat.entities[i].draw ~= nil) then
			Heartbeat.entities[i].draw(Heartbeat.entities[i])
		else
			Heartbeat.draw(Heartbeat.entities[i])
		end
	end
end

-- doEntities: Performs the entities AI if they have them, and checks their collisions
function Heartbeat.doEntities()
	for i=1,#Heartbeat.entities do
		local entity = Heartbeat.entities[i]
		if (entity ~= nil) then
			if (entity.behaivor ~= nil) then
				entity.behaivor(entity)
			end
			entity.dy = entity.dy + Heartbeat.gravity
			if (Heartbeat.checkCollisions(entity) and entity.onCollision ~= nil) then
				entity.onCollision(entity)
			end
		end
	end
end

function Heartbeat.removeEntity(entity)
	for i=1,#Heartbeat.entities do
		if (entity == Heartbeat.entities[i]) then
			table.remove(Heartbeat.entities, i)
		end
	end
end

-- newTile: Initializes a new tile and loads it into Heartbeat
function Heartbeat.newTile(object, x, y)
	local isNewTile = true
	for i=1,#Heartbeat.tiles do
		-- If tile currently exists, set isNewTile to false
		if (Heartbeat.tiles[i].x == x and Heartbeat.tiles[i].y == y and Heartbeat.tiles[i].id == Heartbeat.editor.currentTile) then
			isNewTile = false
		end
	end
	if (isNewTile) then
		Heartbeat.tiles[#Heartbeat.tiles+1] = {
			id = object.id,
			x = x,
			y = y,
			width = object.width,
			height = object.height,
			texture = object.texture,
			scaleX = object.scaleX,
			scaleY = object.scaleY,
			offsetX = object.offsetX,
			offsetY = object.offsetY,
			isSolid = object.isSolid
		}
	end
end

-- drawTiles: Draws the tiles to the screen
function Heartbeat.drawTiles()
	for i=1,#Heartbeat.tiles do
		Heartbeat.draw(Heartbeat.tiles[i])
	end
end

function Heartbeat.newItem(object, x, y)
	Heartbeat.items[#Heartbeat.items+1] = {
		id = object.id,
		x = x,
		y = y,
		dx = 0,
		dy = 0,
		width = object.width,
		height = object.height,
		texture = object.texture,
		scaleX = object.scaleX,
		scaleY = object.scaleY,
		onPickup = object.onPickup
	}
end

function Heartbeat.drawItems()
	for i=1,#Heartbeat.items do
		Heartbeat.draw(Heartbeat.items[i])
	end
end

function Heartbeat.removeItem(item)
	for i=1,#Heartbeat.items do
		if (item == Heartbeat.items[i]) then
			table.remove(Heartbeat.items, i)
		end
	end
end

function Heartbeat.player.addInventoryItem(item)
	if (#Heartbeat.player.inventory == 0) then
		Heartbeat.player.inventory[#Heartbeat.player.inventory+1] = {id = item.id, count = 1}
		return
	end
	local inventoryIndex = Heartbeat.player.hasInventoryItem(item)
	if (inventoryIndex ~= -1) then
		Heartbeat.player.inventory[inventoryIndex].count = Heartbeat.player.inventory[inventoryIndex].count + 1
	else
		Heartbeat.player.inventory[#Heartbeat.player.inventory+1].id = item.id
	end
end

function Heartbeat.player.removeInventoryItem(item)
	local inventoryIndex = Heartbeat.player.hasInventoryItem(item)
	if (inventoryIndex ~= -1) then
		table.remove(Heartbeat.player.inventory, inventoryIndex)
	else
		print("Heartbeat Error: Player has no item of id '" .. item.id .."'")
	end
end

function Heartbeat.player.hasInventoryItem(item)
	for i=1,#Heartbeat.player.inventory do
		if (Heartbeat.player.inventory[i].id == item.id) then
			return i
		else
			return -1
		end
	end
end

function Heartbeat.lookupTile(id)
	for i=1,#Heartbeat.tilesList do
		if (id == Heartbeat.tilesList[i].id) then
			return Heartbeat.tilesList[i]
		end
	end
end

function Heartbeat.lookupEntity(id)
	for i=1,#Heartbeat.entitiesList do
		if (id == Heartbeat.entitiesList[i].id) then
			return Heartbeat.entitiesList[i]
		end
	end
end

function Heartbeat.lookupItem(id)
	for i=1,#Heartbeat.itemsList do
		if (id == Heartbeat.itemsList[i].id) then
			return Heartbeat.itemsList[i]
		end
	end
end

function Heartbeat.dialog.openDialog(dialog)
	if (not Heartbeat.dialog.isOpen) then
		-- Load the speech file and split it
		local rawDialog = love.filesystem.read("dialog/" .. dialog .. ".txt")
		Heartbeat.dialog.dialogLines = split(rawDialog, "\n")
		Heartbeat.dialog.dialogIndex = 0
		Heartbeat.dialog.printedLines = {}
		Heartbeat.dialog.isOpen = true
		Heartbeat.dialog.nextLine()
	else
		Heartbeat.dialog.nextLine()
	end
end

function Heartbeat.dialog.nextLine()
	Heartbeat.dialog.currentLine = Heartbeat.dialog.dialogLines[Heartbeat.dialog.dialogIndex+1]
	Heartbeat.dialog.dialogCharacter = 0
	Heartbeat.dialog.printedLines = {}
	Heartbeat.dialog.dialogIndex = Heartbeat.dialog.dialogIndex + 1
	-- Out of bounds check
	if (Heartbeat.dialog.currentLine == nil or Heartbeat.dialog.currentLine == "") then
		Heartbeat.dialog.isOpen = false
		return
	end

	-- Removing newlines
	local strippedString = ""
	for i=1,string.len(Heartbeat.dialog.currentLine) do
		if (string.sub(Heartbeat.dialog.currentLine, i, i) ~= "\n") then
			strippedString = strippedString .. string.sub(Heartbeat.dialog.currentLine, i, i)
		end
	end
	Heartbeat.dialog.currentLine = strippedString

	if (string.sub(Heartbeat.dialog.currentLine, 1, 1) == "[") then
		for i=1,#Heartbeat.dialog.speakers do
			if (Heartbeat.dialog.currentLine == "[" .. Heartbeat.dialog.speakers[i] .. "]") then
				Heartbeat.dialog.speaker = Heartbeat.dialog.speakers[i]
				Heartbeat.dialog.nextLine()
				-- Add portrait later
			end
		end
	end
end

function Heartbeat.dialog.drawDialog()
	-- Drawing background
	love.graphics.setColor(0, 0, .5, .8)
	love.graphics.rectangle("fill", 0, windowHeight - 150, windowWidth, 150)
	love.graphics.rectangle("fill", 0, windowHeight - 180, 100, 30)
	-- Drawing outline
	love.graphics.setColor(0, 0, 1, .8)
	love.graphics.rectangle("line", 0, windowHeight - 150, windowWidth, 150)
	love.graphics.rectangle("line", 0, windowHeight - 180, 100, 30)
	-- Drawing speaker
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(Heartbeat.dialog.speaker, Heartbeat.dialog.font, 0, windowHeight - 180)
	-- Creating text lines
	local firstLine = string.sub(Heartbeat.dialog.currentLine, 0, Heartbeat.dialog.dialogCharacter)
	local previousLength = 0
	if (Heartbeat.dialog.printedLines[#Heartbeat.dialog.printedLines] ~= nil) then
		for i=1,#Heartbeat.dialog.printedLines do
			previousLength = previousLength + string.len(Heartbeat.dialog.printedLines[i])
		end
	end
	if (Heartbeat.dialog.font:getWidth(string.sub(Heartbeat.dialog.currentLine, previousLength, previousLength + Heartbeat.dialog.dialogCharacter)) > windowWidth - 200) then
		Heartbeat.dialog.printedLines[#Heartbeat.dialog.printedLines+1] = string.sub(Heartbeat.dialog.currentLine, previousLength, previousLength + Heartbeat.dialog.dialogCharacter)
		Heartbeat.dialog.dialogCharacter = 0
	else
		Heartbeat.dialog.dialogCharacter = Heartbeat.dialog.dialogCharacter + 1
	end
	-- Print all lines
	for i=1,#Heartbeat.dialog.printedLines do
		if (i == #Heartbeat.dialog.printedLines) then
			love.graphics.print(string.sub(Heartbeat.dialog.currentLine, previousLength, previousLength + Heartbeat.dialog.dialogCharacter), Heartbeat.dialog.font, 100, windowHeight - 150 + (i*30))
		end
		-- Print the in-progress line
		love.graphics.print(Heartbeat.dialog.printedLines[i], Heartbeat.dialog.font, 100, windowHeight - 150 + ((i-1)*30))
	end
	-- Fallback for if there's only one line
	if (#Heartbeat.dialog.printedLines == 0) then
		love.graphics.print(firstLine, Heartbeat.dialog.font, 100, windowHeight - 150)
	end
end

function Heartbeat.editor.drawEditor()
	if (Heartbeat.editor.isActive) then
		if (Heartbeat.editor.mode == "tile") then
			Heartbeat.debugLine = "Current Tile: " .. Heartbeat.tilesList[Heartbeat.editor.currentTile].id .. "\n"
		elseif (Heartbeat.editor.mode == "entity") then
			Heartbeat.debugLine = "Current Entity: " .. Heartbeat.entitiesList[Heartbeat.editor.currentEntity].id .. "\n"
		elseif (Heartbeat.editor.mode == "item") then
			Heartbeat.debugLine = "Current Item: " .. Heartbeat.itemsList[Heartbeat.editor.currentItem].id .. "\n"
		end
		Heartbeat.debugLine = Heartbeat.debugLine .. "Mouse Position: " .. love.mouse.getX() .. " " .. love.mouse.getY() .. "\n"
		-- Drawing current tile/entity/item info
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(Heartbeat.debugLine)
		-- Drawing the commandModeLine
		if (Heartbeat.editor.commandMode) then
			love.graphics.setColor(0, 1, 0, 1)
			love.graphics.print(":" .. Heartbeat.editor.commandModeLine, 0, windowHeight - 20)
		end
		-- Drawing the cursor
		love.graphics.setColor(1, 1, 1, .5)
		love.graphics.rectangle("fill", math.floor(love.mouse.getX() / 25) * 25, math.floor(love.mouse.getY() / 25) * 25, 25, 25)
	end
end

function Heartbeat.editor.handleInput(key)
	if (Heartbeat.editor.commandMode) then
		if (key == "return") then
			Heartbeat.editor.executeCommand()
			Heartbeat.editor.commandModeLine = ""
			Heartbeat.editor.commandMode = false
		elseif (key == "backspace") then
				Heartbeat.editor.commandModeLine = Heartbeat.editor.commandModeLine:sub(1, -2)
		else
			if (key == "space") then
				key = " "
			-- Removing invalid characters
			elseif (key == "lshift" or key == "rshift" or key == "capslock"
				or key == "lalt" or key == "ralt" or key == "tab"
				or key == "lctrl" or key == "rctrl" or key == "up"
				or key == "down" or key == "left" or key == "right"
				or key == "escape" or key == "m1" or key == "m2") then
				key = ""
			end
			Heartbeat.editor.commandModeLine = Heartbeat.editor.commandModeLine .. key
		end
	end
	-- Handle mouse click, place tile/entity/item
	if (key == 1) then
		local snapx = math.floor((love.mouse.getX() + Camera.x) / 25) * 25
		local snapy = math.floor((love.mouse.getY() + Camera.y) / 25) * 25
		if (Heartbeat.editor.mode == "tile") then
			local tileInfo = Heartbeat.tilesList[Heartbeat.editor.currentTile]
			Heartbeat.newTile(tileInfo, snapx, snapy)
		end
		if (Heartbeat.editor.mode == "entity") then
			local entityInfo = Heartbeat.entitiesList[Heartbeat.editor.currentEntity]
			Heartbeat.newEntity(entityInfo, love.mouse.getX(), love.mouse.getY())
		end
		if (Heartbeat.editor.mode == "item") then
			local itemInfo = Heartbeat.itemsList[Heartbeat.editor.currentItem]
			Heartbeat.newItem(itemInfo, love.mouse.getX(), love.mouse.getY())
		end
	end
	-- Handle right mouse click, remove tile
	if (key == 2) then
		if (Heartbeat.editor.mode == "tile") then
			for i=1,#Heartbeat.tiles do
				local snapx = math.floor((love.mouse.getX() + Camera.x) / 25) * 25
				local snapy = math.floor((love.mouse.getY() + Camera.y) / 25) * 25
				if (Heartbeat.tiles[i].x == snapx and Heartbeat.tiles[i].y == snapy) then
					table.remove(Heartbeat.tiles, i)
					--Level.tileCount = Level.tileCount - 1
					break
				end
			end
		end
		if (Heartbeat.editor.mode == "entity") then
			local mouseHitbox = {
				x = love.mouse.getX(),
				y = love.mouse.getY(),
				width = 1,
				height = 1,
			}
			for i=1,#Heartbeat.entities do
				if (Heartbeat.checkEntityCollision(mouseHitbox, Heartbeat.entities[i])) then
					table.remove(Heartbeat.entities, i)
					break
				end
			end
		end
		if (Heartbeat.editor.mode == "item") then
			local mouseHitbox = {
				x = love.mouse.getX(),
				y = love.mouse.getY(),
				width = 1,
				height = 1,
			}
			for i=1,#Heartbeat.items do
				if (Heartbeat.checkEntityCollision(mouseHitbox, Heartbeat.items[i])) then
					table.remove(Heartbeat.items, i)
					break
				end
			end
		end
	end
	-- Handle swapping between tile/entity/item
	if (key == "down") then
		if (Heartbeat.editor.mode == "tile") then
			Heartbeat.editor.mode = "entity"
		elseif (Heartbeat.editor.mode == "entity") then
			Heartbeat.editor.mode = "item"
		end
	end
	if (key == "up") then
		if (Heartbeat.editor.mode == "entity") then
			Heartbeat.editor.mode = "tile"
		elseif (Heartbeat.editor.mode == "item") then
			Heartbeat.editor.mode = "entity"
		end
	end
	if (key == "left") then
		if (Heartbeat.editor.mode == "tile" and Heartbeat.editor.currentTile > 1) then
			Heartbeat.editor.currentTile = Heartbeat.editor.currentTile -1
		end
		if (Heartbeat.editor.mode == "entity" and Heartbeat.editor.currentEntity > 1) then
			Heartbeat.editor.currentEntity = Heartbeat.editor.currentEntity -1
		end
		if (Heartbeat.editor.mode == "item" and Heartbeat.editor.currentItem > 1) then
			Heartbeat.editor.currentItem = Heartbeat.editor.currentItem - 1
		end
	end
	if (key == "right") then
		if (Heartbeat.editor.mode == "tile" and Heartbeat.editor.currentTile < #Heartbeat.tilesList) then
			Heartbeat.editor.currentTile = Heartbeat.editor.currentTile + 1
		end
		if (Heartbeat.editor.mode == "entity" and Heartbeat.editor.currentEntity < #Heartbeat.entitiesList) then
			Heartbeat.editor.currentEntity = Heartbeat.editor.currentEntity + 1
		end
		if (Heartbeat.editor.mode == "item" and Heartbeat.editor.currentItem < #Heartbeat.itemsList) then
			Heartbeat.editor.currentItem = Heartbeat.editor.currentItem + 1
		end
	end
	-- Enable command mode, for saving/reading
	if (key == ";") then
		Heartbeat.editor.commandMode = true
	end
end

function Heartbeat.editor.executeCommand()
	-- :w <levelname> (writes level to file)
	if (Heartbeat.editor.commandModeLine:sub(1, 1) == "w") then
		if (currentLevel == "" and Heartbeat.editor.commandModeLine:len() < 2) then
			print("Error: No level name defined.\n Usage: :w <filename>")
		else
			local args = split(Heartbeat.editor.commandModeLine, " ")
			Heartbeat.editor.saveLevel(args[2])
		end
	-- :o <filename> (reads level from file)
	elseif (Heartbeat.editor.commandModeLine:sub(1, 1) == "o") then
		if (Heartbeat.editor.commandModeLine:len() > 2) then
			Heartbeat.clear()
			local args = split(Heartbeat.editor.commandModeLine, " ")
			Heartbeat.editor.readLevel(args[2])
		end
	-- :set <height/width> (sets level height/width)
	elseif (Heartbeat.editor.commandModeLine:sub(1, 3) == "set") then
		local args = split(Heartbeat.editor.commandModeLine, " ")
		if (args[2] == "height") then
			Heartbeat.levelHeight = args[3]
			print("Level height set to " .. args[3])
		elseif (args[2] == "width") then
			Heartbeat.levelWidth = args[3]
			print("Level width set to " .. args[3])
		else
			print("Error: Invalid arguments.\nUsage: set <variable> <value>")
		end
	-- :room <roomfilename> <doorX> <doorY> <newroomX> <newroomY> (Creates a new door in a level)
	elseif (Heartbeat.editor.commandModeLine:sub(1, 4) == "room") then
		local args = split(Heartbeat.editor.commandModeLine, " ")
		Heartbeat.rooms[#Heartbeat.rooms+1] = {
			location = args[2],
			x = tonumber(args[3]),
			y = tonumber(args[4]),
			newX = tonumber(args[5]),
			newY = tonumber(args[6])
		}
	-- :clear (clears level)
	elseif (Heartbeat.editor.commandModeLine:sub(1, 5) == "clear") then
		Heartbeat.clear()
	-- :list (Prints all the levels to the commandline
	elseif (Heartbeat.editor.commandModeLine:sub(1, 4) == "list") then
		local levelList = love.filesystem.getDirectoryItems("levels")		for i=1,#levelList do
		print("Levels:")
			print(levelList[i])
		end
	else
		print("Error. Command not found.")
	end
end

function Heartbeat.editor.saveLevel(levelName)
	levelName = "levels/" .. levelName -- Writing levels to the levels directory
	-- Creating a file 'levelName' and adding the width/height
	love.filesystem.write(levelName, Heartbeat.levelWidth .. " " .. Heartbeat.levelHeight .. "\n")
	-- Write the doors to the file
	love.filesystem.append(levelName, "DOORS\n")
	for i=1,#Heartbeat.rooms do
		love.filesystem.append(levelName, Heartbeat.rooms[i].x .. " " .. Heartbeat.rooms[i].y .. " " .. Heartbeat.rooms[i].location .. " " .. Heartbeat.rooms[i].newX .. " " .. Heartbeat.rooms[i].newY .. "\n")
	end
	-- Write the tiles to the file
	love.filesystem.append(levelName, "TILES\n")
	for i=1,#Heartbeat.tiles do
		love.filesystem.append(levelName, Heartbeat.tiles[i].x .. " " .. Heartbeat.tiles[i].y .. " " .. Heartbeat.tiles[i].id .. "\n")
	end
	-- Write the entities to the file
	love.filesystem.append(levelName, "ENTITIES\n")
	for i=1,#Heartbeat.entities do
		love.filesystem.append(levelName, Heartbeat.entities[i].x .. " " .. Heartbeat.entities[i].y .. " " .. Heartbeat.entities[i].id .. "\n")
	end
	-- Print success message
	print("Written '" .. levelName .. "' to file.")
end

function Heartbeat.editor.readLevel(levelName)
	local rawLevelData = love.filesystem.read("levels/" .. levelName)
	-- Check if file exists
	if (rawLevelData == nil) then
		print("File '" .. levelName .. "' not found.")
		return
	end

	local levelLines = split(rawLevelData, "\n")

	-- Extracting the dimensions of the level
	local levelDimensions = split(levelLines[1], " ")
	Heartbeat.levelWidth = tonumber(levelDimensions[1])
	Heartbeat.levelHeight = tonumber(levelDimensions[2])

	-- Values needed for the loops
	local levelLineData
	local i = 3 -- For door loop (line 1 is dimensions, 2 is a title, so 3 is where we start)
	local j = 0 -- For tile loop
	local k = 0 -- For item loop

	-- Load the doors
	for i=i,#levelLines do
		if (levelLines[i] == "TILES") then
			j = i+1 -- To skip the TILES line
			break
		end
		levelLineData = split(levelLines[i], " ")
		Heartbeat.rooms = {}
		Heartbeat.rooms[#Level.rooms+1] = {x = tonumber(levelLineData[1]), y = tonumber(levelLineData[2]), location = levelLineData[3], newX = tonumber(levelLineData[4]), newY = tonumber(levelLineData[5])}
	end

	-- Load the tiles
	for j=j,#levelLines do
		if (levelLines[j] == "ENTITIES") then
			k = j+1 -- To skip the ENTITIES line
			break
		end
		levelLineData = split(levelLines[j], " ")
		local tile = Heartbeat.lookupTile(levelLineData[3])
		print(tile.scaleX)
		local tileData = {
			id = tile.id,
			width = tile.width,
			height = tile.height,
			texture = tile.texture,
			scaleX = tile.scaleX,
			scaleY = tile.scaleY,
			offsetX = tile.offsetX,
			offsetY = tile.offsetY,
			isSolid = tile.isSolid
		}
		Heartbeat.newTile(tileData, tonumber(levelLineData[1]), tonumber(levelLineData[2]))
		--Heartbeat.tiles[Level.tileCount+1] = {x = tonumber(levelLineData[1]), y = tonumber(levelLineData[2]), id = tonumber(levelLineData[3])}
	end

	-- Load the entities
	for k=k,#levelLines-1 do -- -1 to avoid EOF
		--if (levelLines[i] == "ITEMS") then
			--l = k
			--break
		--end
		levelLineData = split(levelLines[k], " ")
		local entity = Heartbeat.lookupEntity(levelLineData[3])
		local entityData = {
			id = entity.id,
			height = entity.height,
			width = entity.width,
			health = entity.health,
			attack = entity.attack,
			draw = entity.draw
		}
		Heartbeat.newEntity(entityData, tonumber(levelLineData[1]), tonumber(levelLineData[2]))
		--Heartbeat.spawnEntity(tonumber(levelLineData[1]), tonumber(levelLineData[2]), tonumber(levelLineData[3]))
	end
	print("Loaded '" .. levelName .. "' successfully.")
end

-- clear: Clears all the entities and tiles
function Heartbeat.clear()
	Heartbeat.tiles = {}
	Heartbeat.entities = {}
end

function Heartbeat.checkRooms()
	for i=1,#Heartbeat.rooms do
		if ((Heartbeat.player.x >= Heartbeat.rooms[i].x and Heartbeat.player.x <= Heartbeat.rooms[i].x + 25) and Heartbeat.player.y == Heartbeat.rooms[i].y) then
			Heartbeat.gotoRoom(Heartbeat.rooms[i].location, Heartbeat.rooms[i].newX, Heartbeat.rooms[i].newY)
		end
	end
end

function Heartbeat.gotoRoom(room, x, y)
	print("Room " .. room .. " loaded.")
	Heartbeat.clear()
	Heartbeat.editor.readLevel(room)
	Heartbeat.player.x = x
	Heartbeat.player.y = y
end

-- checkCollisions: Checks the collisions of all the entities against the tiles
function Heartbeat.checkCollisions(entity)
	local attemptedX = entity.x + entity.dx
	local attemptedY = entity.y + entity.dy
	local collisionX = false
	local collisionY = false

	for i=1,#Heartbeat.tiles do
		if (Heartbeat.tiles[i].isSolid) then
			if (entity.x < Heartbeat.tiles[i].x + Heartbeat.tiles[i].width and entity.x + entity.width > Heartbeat.tiles[i].x and attemptedY < Heartbeat.tiles[i].y + Heartbeat.tiles[i].height and attemptedY + entity.height > Heartbeat.tiles[i].y) then
				entity.dy = 0
				entity.isFalling = false
				collisionY = true
			end
			if (attemptedX < Heartbeat.tiles[i].x + Heartbeat.tiles[i].width and attemptedX + entity.width > Heartbeat.tiles[i].x and entity.y < Heartbeat.tiles[i].y + Heartbeat.tiles[i].height and entity.y + entity.height > Heartbeat.tiles[i].y) then
				collisionX = true
			end
		end
	end

	-- Applying Forces
	if (not collisionY) then
		entity.y = entity.y + entity.dy
	end
	if (not collisionX) then
		entity.x = entity.x + entity.dx
	end

	-- Return a bool if they collided
	if (not collisionX and not collisionY) then
		return false
	else
		return true
	end
end

-- checkEntityCollisons: Compares two entities, returns true if they collide
function Heartbeat.checkEntityCollision(entity1, entity2)
	-- Quick duct tape for if entity is removed during the loop
	if (entity1 == nil or entity2 == nil) then return end
	if (Camera.convert("x", entity1.x) < Camera.convert("x", entity2.x) + entity2.width and ((Camera.convert("x", entity1.x) + entity1.width) > (Camera.convert("x", entity2.x))) and Camera.convert("y", entity1.y) < Camera.convert("y", entity2.y) + entity2.height and ((Camera.convert("y", entity1.y) + entity1.height) > (Camera.convert("y", entity2.y)))) then
		return true
	else
		return false
	end
end

-- setDimensions: Sets the dimensions of the level
function Heartbeat.setDimensions(width, height)
	Heartbeat.levelWidth = width
	Heartbeat.levelHeight = height
end

-- drawBackground: Draws the background, currently supports only solid colors
function Heartbeat.drawBackground()
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)
end

-- Heartbeat's main function
function Heartbeat.beat()
	if (not Heartbeat.editor.isActive) then
		Heartbeat.doEntities()
		Heartbeat.doPlayer()
		Heartbeat.checkRooms()
	end
	Heartbeat.drawBackground()
	Heartbeat.drawTiles()
	Heartbeat.drawEntities()
	Heartbeat.drawItems()
	Heartbeat.drawPlayer()
	Heartbeat.editor.drawEditor()
	if (Heartbeat.dialog.isOpen) then
		Heartbeat.dialog.drawDialog()
	end
end

