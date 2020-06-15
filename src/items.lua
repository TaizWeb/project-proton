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
	if ((Heartbeat.player.health + 25) < Player.maxHealth) then
		Heartbeat.player.health = Heartbeat.player.health + 25
	else
		Heartbeat.player.health = Player.maxHealth
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
	Player.maxMatter = Player.maxMatter + 5
	Player.matter = Player.matter + 5
	Heartbeat.removeItem(this)
	if (Heartbeat.levelName == "bunker5") then
		Player.flags.hasFirstMatter = true
	end
	if (Heartbeat.levelName == "cave3") then
		Player.flags.hasSecondMatter = true
	end
	if (Heartbeat.levelName == "cave6") then
		Player.flags.hasThirdMatter = true
	end
	Player.setNewObjective("Dark Matter Storage Increased by 5 Units")
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
	Heartbeat.player.health = Heartbeat.player.health + 100
	Heartbeat.removeItem(this)
	if (Heartbeat.levelName == "bunker6") then
		Player.flags.hasFirstHealth = true
	end
	if (Heartbeat.levelName == "cave4") then
		Player.flags.hasSecondHealth = true
	end
	Player.setNewObjective("Health Increased by 100 Units")
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
	Player.setNewObjective("Long Jump Obtained: Shift-jump to jump higher")
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
	Player.setNewObjective("Gravity Upgrade Obtained: Left-ctrl to reverse gravity")
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

