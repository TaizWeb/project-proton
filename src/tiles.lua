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

EscapePod = {
	id = "escape_pod",
	texture = love.graphics.newImage("assets/tiles/escape.png"),
	height = 1,
	width = 1,
	scaleX = 3,
	offsetY = -6,
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

Bed = {
	id = "bed",
	texture = love.graphics.newImage("assets/tiles/bed.png"),
	height = 16,
	width = 32,
	offsetX = 0,
	offsetY = -3,
	scaleX = 4,
	scaleY = 4,
	isSolid = false
}

BloodyBed = {
	id = "bed_bloody",
	texture = love.graphics.newImage("assets/tiles/bed-bloody.png"),
	height = 16,
	width = 32,
	offsetX = 0,
	offsetY = -3,
	scaleX = 4,
	scaleY = 4,
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

Cobble = {
	id = "cobble",
	texture = love.graphics.newImage("assets/tiles/cobble.png"),
	height = 25,
	width = 25,
	scaleX = 25/16,
	scaleY = 25/16,
	isSolid = true
}

Stalagtite = {
	id = "stalagtite",
	texture = love.graphics.newImage("assets/tiles/stalagtite.png"),
	height = 16,
	width = 16,
	scaleX = 3,
	scaleY = 3,
	isSolid = false
}

Pebble = {
	id = "pebble",
	texture = love.graphics.newImage("assets/tiles/pebble.png"),
	height = 16,
	width = 16,
	scaleX = 3,
	scaleY = 3,
	offsetY = -1,
	isSolid = false
}

CobbleWeb = {
	id = "cobble_web",
	texture = love.graphics.newImage("assets/tiles/cobble-web.png"),
	height = 25,
	width = 25,
	scaleX = 25/16,
	scaleY = 25/16,
	isSolid = true
}

BunkerWeb = {
	id = "bunker_web",
	texture = love.graphics.newImage("assets/tiles/bunker-web.png"),
	height = 25,
	width = 25,
	scaleX = 25/16,
	scaleY = 25/16,
	isSolid = true
}

BunkerExtWeb = {
	id = "bunker_ext_web",
	texture = love.graphics.newImage("assets/tiles/bunker-ext-web.png"),
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

LockedDoor = {
	id = "lockeddoor",
	texture = love.graphics.newImage("assets/tiles/lockeddoor.png"),
	height = 75,
	width = 25,
	isSolid = true
}

Lift = {
	id = "lift",
	texture = love.graphics.newImage("assets/tiles/lift.png"),
	height = 64 * 2,
	width = 64 * 2,
	scaleX = 3.5,
	scaleY = 3,
	isSolid = false
}

Facade = {
	id = "facade",
	texture = love.graphics.newImage("assets/tiles/door.png"),
	height = 25,
	width = 25,
	scaleX = 0,
	scaleY = 0,
	isSolid = true
}
