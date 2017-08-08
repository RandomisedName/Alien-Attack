player = {}

function player.load()
	player.x = W/2
	player.y = H*0.2
	player.screenX = W*0.5
	player.xVel = 0
	player.yVel = 0
	player.speed = 100
	player.friction = 0.2
	player.r = 0
	player.beaming = false
	player.scrolling = false
	player.img = love.graphics.newImage("img/nlo.png")
	player.h = player.img:getHeight()
	player.anim = newAnimation(player.img, 700, 182, 0.35, 5)
	player.anim:play()
end

function player.update(dt)
	player.anim:update(dt)
	
	if (love.keyboard.isDown('a') or love.keyboard.isDown("left")) and not (love.keyboard.isDown('d') or love.keyboard.isDown("right")) then	
		player.xVel = player.xVel - player.speed*dt
	end
	if (love.keyboard.isDown('d') or love.keyboard.isDown("right")) and not (love.keyboard.isDown('a') or love.keyboard.isDown("left"))then	
		player.xVel = player.xVel + player.speed*dt
	end
	
	-- Трение
	player.xVel = player.xVel * (1 - math.min(player.friction*dt, 1))
	player.x = player.x + player.xVel*dt
	player.screenX = player.screenX + player.xVel*dt
	player.r = player.xVel/1000
	
	player.beaming = love.keyboard.isDown('space')
	
	player.screenX = math.min(math.max(player.screenX, W*0.2), W*0.8)
	player.scrolling = (player.screenX == W*0.2) or (player.screenX == W*0.8)
	
	function player.keypressed(key)
		
	end
end

function player.draw()
	if ui.info then
		love.graphics.setColor(205, 208, 214)
		love.graphics.setPointSize(4)
		love.graphics.points(player.screenX, player.y)
		love.graphics.line(player.screenX-15*math.cos(player.r), player.y-15*math.sin(player.r), player.screenX+15*math.cos(player.r), player.y+15*math.sin(player.r))
		if player.beaming then
			love.graphics.setColor(158, 195, 255)
			love.graphics.line(player.screenX, player.y, player.screenX, H)
		end
	end
	
	
	love.graphics.setColor(255, 255, 255)
		--                 x          y         поворот    растижение по x, y     сдвиг x,y
	player.anim:draw(math.floor(player.screenX), math.floor(player.y), player.r) --отрисовка по х,y и поворот в радианах
end
