Pained = {
	id = "pained",
	texture = love.graphics.newImage("assets/enemies/pained.png"),
	scaleX = 2.3,
	scaleY = 2.3,
	height = 24,
	width = 48,
	offsetX = 0,
	offsetY = 3,
	isEnemy = false,
	opacity = .5
}

function Pained.draw(this)
	love.graphics.setColor(1, 1, 1, this.opacity)
	love.graphics.draw(Pained.texture, Camera.convert("x", this.x), Camera.convert("y", this.y), 0, Pained.scaleX, Pained.scaleY, Pained.offsetX, Pained.offsetY)
end

function Pained.behaivor(this)
	if (Heartbeat.levelName == "cave1") then
		if (Player.seen) then
			this.opacity = 0
		end
		if (Camera.y < 100) then
			this.seen = true
		end
		if (Camera.y > 100 and this.seen) then
			Player.seen = true
			this.opacity = 0
		end
		this.dy = -.5
	elseif (Heartbeat.levelName == "spider10" and Player.seenTerm == nil) then
		love.audio.stop()
		-- GET OUT OF MY HEAD GET OUT OF MY HEAD GET OUT OF MY HEAD GET OU
		if (this.frames == nil) then
			this.frames = 0
			this.opacity = 0
		end
		if (Heartbeat.dialog.isOpen) then
			this.frames = this.frames + 1
		end
		if (this.frames > 250 and this.getout == nil) then
			Heartbeat.dialog.isOpen = false
			Heartbeat.dialog.openDialog("GETOUT")
			Heartbeat.redText = true
			this.opacity = 1
			this.getout = true
		end
		if (this.getout) then
			this.dx = 2.5
		end
		if (Heartbeat.checkEntityCollision(Heartbeat.player, this) and this.opacity == 1) then
			Heartbeat.dialog.isOpen = false
			Heartbeat.redText = nil
			Player.seenTerm = true
			Heartbeat.gotoRoom("spider10", 30, 390)
		end
	else
		this.opacity = 0
	end
	this.dy = -.5
end

