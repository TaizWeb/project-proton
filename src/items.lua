HealthPickup = {
	id = "healthpickup",
	texture = love.graphics.newImage("assets/misc/healthpickup.png"),
	height = 16,
	width = 16,
	scaleX = 1,
	scaleY = 1,
	isEnemy = false
}

function HealthPickup.onPickup(this)
	if ((Player.health + 25) < Player.maxHealth) then
		Player.health = Player.health + 25
	else
		Player.health = Player.maxHealth
	end
	Heartbeat.removeItem(this)
end

DarkPickup = {
	id = "darkpickup",
	texture = love.graphics.newImage("assets/misc/darkpickup.png"),
	height = 16,
	width = 16,
	scaleX = 1,
	scaleY = 1,
	isEnemy = false
}

function DarkPickup.onPickup(this)
	if ((Player.matter + 5) < Player.maxMatter) then
		Player.matter = Player.matter + 5
	else
		Player.matter = Player.maxMatter
	end
	Heartbeat.removeItem(this)
end

DarkMatterUpgrade = {
	id = "matterupgrade",
	texture = love.graphics.newImage("assets/items/darkmatter.png"),
	height = 20,
	width = 20,
	scaleX = 1.5,
	scaleY = 1.5,
	isEnemy = false
}

function DarkMatterUpgrade.onPickup(this)
	Player.maxMatter = Player.maxMatter + 10
	Player.matter = Player.matter + 10
	Heartbeat.removeItem(this)
	if (Heartbeat.levelName == "bunker5") then
		Player.flags.hasFirstMatter = true
	end
end

HealthTankUpgrade = {
	id = "healthupgrade",
	texture = love.graphics.newImage("assets/items/healthtank.png"),
	height = 20,
	width = 20,
	scaleX = 1.5,
	scaleY = 1.5,
	isEnemy = false
}

-- TODO: Add level flags so they don't respawn
function HealthTankUpgrade.onPickup(this)
	Player.maxHealth = Player.maxHealth + 100
	Heartbeat.removeItem(this)
end

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

function LongJumpUpgrade.onPickup(this)
	Player.hasJumpUpgrade = true
	Heartbeat.removeItem(this)
end

GravityUpgrade = {
	id = "gravityupgrade",
	texture = love.graphics.newImage("assets/items/gravity.png"),
	height = 20,
	width = 20,
	scaleX = 1.5,
	scaleY = 1.5,
	isEnemy = false
}

function GravityUpgrade.onPickup(this)
	Player.hasGravityUpgrade = true
	Heartbeat.removeItem(this)
end

ChargeBeamUpgrade = {
	id = "chargeupgrade",
	texture = love.graphics.newImage("assets/items/charge.png"),
	height = 20,
	width = 20,
	scaleX = 1.5,
	scaleY = 1.5,
	isEnemy = false
}

function ChargeBeamUpgrade.onPickup(this)
	Player.hasChargeBeamUpgrade = true
	Heartbeat.removeItem(this)
end

TriBeamUpgrade = {
	id = "tribeamupgrade",
	texture = love.graphics.newImage("assets/items/tribeam.png"),
	height = 20,
	width = 20,
	scaleX = 1.5,
	scaleY = 1.5,
	isEnemy = false
}

function TriBeamUpgrade.onPickup(this)
	Player.hasTriBeamUpgrade = true
	Heartbeat.removeItem(this)
end

