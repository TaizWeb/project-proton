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

function HealthTankUpgrade.onPickup(this)
	print("Grabbed item upgrade")
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
