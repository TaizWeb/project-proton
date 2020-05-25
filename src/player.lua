Player = {
	height = 60,
	width = 25,
	health = 99,
	texture = love.graphics.newImage("assets/proton/proton-firing.png"),
	idle = love.graphics.newImage("assets/proton/proton-firing.png"),
	walk = {
		love.graphics.newImage("assets/proton/walk/proton-walk1.png"),
		love.graphics.newImage("assets/proton/walk/proton-walk2.png"),
		love.graphics.newImage("assets/proton/walk/proton-walk3.png"),
		love.graphics.newImage("assets/proton/walk/proton-walk4.png"),
		love.graphics.newImage("assets/proton/walk/proton-walk5.png"),
		love.graphics.newImage("assets/proton/walk/proton-walk6.png")
	},
	crouch = {
		love.graphics.newImage("assets/proton/crouch/proton-crouch1.png"),
		love.graphics.newImage("assets/proton/crouch/proton-crouch2.png"),
		love.graphics.newImage("assets/proton/crouch/proton-crouch3.png")
	}
}

function Player.draw(this)
	local scaleX = 2
	local scaleY = 2
	local offsetX = 10
	local offsetY = 2
	-- Determine which way the player faces
	if (Heartbeat.player.dx < 0) then
		Heartbeat.player.forwardFace = false
		Heartbeat.player.isWalking = true
	elseif (Heartbeat.player.dx > 0) then
		Heartbeat.player.forwardFace = true
		Heartbeat.player.isWalking = true
	else
		Heartbeat.player.isWalking = false
		Heartbeat.player.walkFrames = 0
		Player.texture = Player.idle
	end
	if (not Heartbeat.player.forwardFace) then
		scaleX = -2
		offsetX = 22
	end
	-- Walk animation
	if (Heartbeat.player.isWalking) then
		Heartbeat.player.walkFrames = Heartbeat.player.walkFrames + 2
		if (Heartbeat.player.walkFrames >= 60) then
			Heartbeat.player.walkFrames = 0
		end
		Player.texture = Player.walk[1 + math.floor(Heartbeat.player.walkFrames / 10)]
	end
	if (Heartbeat.player.isCrouched) then
		if (Heartbeat.player.crouchFrames < 3) then
			Player.texture = Player.crouch[2]
			Heartbeat.player.crouchFrames = Heartbeat.player.crouchFrames + 1
		else
			Player.texture = Player.crouch[3]
		end
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Health: " .. Heartbeat.player.health)
	if (not (Heartbeat.player.cooldownFrames <= 0)) then
		love.graphics.setColor(1, 1, 1, .5)
	end
	love.graphics.draw(Player.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, scaleX, scaleY, offsetX, offsetY)
end

function Player.setCrouch()
	Heartbeat.player.isCrouched = true
	Heartbeat.player.crouchFrames = 0
end

function Player.shoot()
	if (not Heartbeat.player.isCrouched) then
		Heartbeat.newEntity(BasicShot, Heartbeat.player.x+20, Heartbeat.player.y+5)
	else
		Heartbeat.newEntity(BasicShot, Heartbeat.player.x+25, Heartbeat.player.y+25)
	end
end
