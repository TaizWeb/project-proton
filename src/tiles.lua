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
