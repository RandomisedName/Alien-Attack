player = {}

function player.load()
	player.x = W/2
	player.y = H*0.2
	player.screenX = W*0.5
	player.xVel = 0
	player.yVel = 0
	player.xSpeed = 100
	player.ySpeed = 400
	player.xFriction = 0.2
	player.yFriction = 3
	player.r = 0
	player.beaming = false
	player.scrolling = false
	player.img = love.graphics.newImage("img/nlo.png")
	player.anim = newAnimation(player.img, 700, 182, 0.35, 5)
	player.h = player.img:getHeight()
	player.w = player.img:getWidth() / 5

	player.control = {}
	player.control['left'] = {'a', 'left'}
	player.control['right'] = {'d', 'right'}
	player.control['up'] = {'w', 'up'}
	player.control['down'] = {'s', 'down'}

	player.anim:play()
end

function player.update(dt)
	player.anim:update(dt)

	-- Горизонтальное управление
	if (love.keyboard.isDown('a') or love.keyboard.isDown("left")) and not (love.keyboard.isDown('d') or love.keyboard.isDown("right")) then
		player.xVel = player.xVel - player.xSpeed*dt
	end
	if (love.keyboard.isDown('d') or love.keyboard.isDown("right")) and not (love.keyboard.isDown('a') or love.keyboard.isDown("left"))then
		player.xVel = player.xVel + player.xSpeed*dt
	end

	-- Вертикальное управление
	if love.keyboard.isDown('w') and not love.keyboard.isDown('s') then
		player.yVel = player.yVel - player.ySpeed*dt
	end
	if love.keyboard.isDown('s') and not love.keyboard.isDown('w') then
		player.yVel = player.yVel + player.ySpeed*dt
	end

	-- Трение
	player.xVel = player.xVel * (1 - math.min(player.xFriction*dt, 1))
	player.yVel = player.yVel * (1 - math.min(player.yFriction*dt, 1))
	player.yVel = math.min(player.yVel, 100)
	player.x = player.x + player.xVel*dt
	player.y = player.y + player.yVel*dt
	player.screenX = player.screenX + player.xVel*dt
	player.r = player.xVel/2000

	-- Вертикальное ограничение
	if player.y < 0 then
		player.yVel = player.yVel - player.y*100*dt
	end
	if player.y > H/2 then
		player.yVel = player.yVel - (player.y-H/2)*100*dt
	end

	player.beaming = love.keyboard.isDown('space')

	player.screenX = math.min(math.max(player.screenX, W*0.2), W*0.8)
	player.scrolling = (player.screenX == W*0.2) or (player.screenX == W*0.8)

	function player.keypressed(key)

	end
end

function player.draw()
	love.graphics.setColor(255, 255, 255)
		--                 x          y         поворот    растижение по x, y     сдвиг x,y
	player.anim:draw(math.floor(player.screenX), math.floor(player.y), player.r, 0.25, 0.25, player.w/2, player.h/2) --отрисовка по х,y и поворот в радианах

	if ui.info then
		love.graphics.setColor(205, 208, 214)
		love.graphics.setPointSize(4)
		love.graphics.points(player.screenX, player.y)
		love.graphics.line(player.screenX-15*math.cos(player.r), player.y-15*math.sin(player.r), player.screenX+15*math.cos(player.r), player.y+15*math.sin(player.r))
		love.graphics.setColor(255, 0, 0)
		love.graphics.line(player.screenX, player.y, player.screenX+player.xVel, player.y+player.yVel)
		if player.beaming then
			love.graphics.setColor(158, 195, 255)
			love.graphics.line(player.screenX, player.y, player.screenX, H)
		end
	end
end
