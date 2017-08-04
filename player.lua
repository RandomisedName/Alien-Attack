player = {}

function player.load()
	player.x = W/2
	player.y = H*0.2
	player.xVel = 0
	player.yVel = 0
	player.speed = 100
end

function player.update(dt)
	player.x = player.x + player.xVel*dt
	if love.keyboard.isDown('a') and not love.keyboard.isDown('d') then	
		player.xVel = player.xVel - player.speed*dt
	end
	if love.keyboard.isDown('d') and not love.keyboard.isDown('a') then	
		player.xVel = player.xVel + player.speed*dt
	end
end

function player.draw()
	if ui.info then
		love.graphics.setColor(255, 0, 0)
		love.graphics.setPointSize(4)
		love.graphics.points(player.x, player.y)
	end
end