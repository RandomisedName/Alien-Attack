player = {}

function player.load()
	player.img = love.graphics.newImage("img/ufo/ufo.png")
	player.anim = newAnimation(player.img, 175, 46, 0.35, 5)
	player.h = player.img:getHeight()
	player.w = player.img:getWidth() / 5
	player.x = W/2
	player.y = -player.h
	player.screenX = W*0.5
	player.xVel = 0
	player.yVel = 0
	player.xSpeed = 100
	player.ySpeed = 400
	player.xFriction = 0.2
	player.yFriction = 3
	player.hMove = 0
	player.vMove = 0
	player.r = 0
	player.beaming = false
	player.beamCharge = 100
	player.beamOff = false
	player.scrolling = false
	player.hp = 100

	player.control = {}
	player.control['left'] = {'a', 'left'}
	player.control['right'] = {'d', 'right'}
	player.control['up'] = {'w', 'up'}
	player.control['down'] = {'s', 'down'}
	player.control['beam'] = {'space'}

	player.anim:play()
end

function player.update(dt)
	if gamestate == 'intro' then
		player.y = player.y + 20*dt
		if player.y >= player.h then
			gamestate = 'playing'
			for n = 1, world.guy.count, 1 do
				world.guy[n].action = 2
			end
		end
	end

	if gamestate == 'playing' then
		player.anim:update(dt)

		-- Горизонтальное управление
		player.hMove = 0
		for i, key in ipairs(player.control['left']) do
			if love.keyboard.isDown(key) then
				player.hMove = player.hMove - 1
			end
		end
		for i, key in ipairs(player.control['right']) do
			if love.keyboard.isDown(key) then
				player.hMove = player.hMove + 1
			end
		end
		if math.abs(player.hMove) > 1 then
			player.hMove = 0
		end

		player.xVel = player.xVel + player.xSpeed*player.hMove*dt

		-- Вертикальное управление
		player.vMove = 0
		for i, key in ipairs(player.control['up']) do
			if love.keyboard.isDown(key) then
				player.vMove = player.vMove - 1
			end
		end
		for i, key in ipairs(player.control['down']) do
			if love.keyboard.isDown(key) then
				player.vMove = player.vMove + 1
			end
		end
		if  math.abs(player.vMove) > 1 then
			player.vMove = 0
		end

		player.yVel = player.yVel + player.ySpeed*player.vMove*dt

		-- Трение
		player.xVel = player.xVel * (1 - math.min(player.xFriction*dt, 1))
		player.yVel = player.yVel * (1 - math.min(player.yFriction*dt, 1))
		player.yVel = math.min(player.yVel, 100)
		player.x = player.x + player.xVel*dt
		player.y = player.y + player.yVel*dt
		player.screenX = player.screenX + player.xVel*dt
		player.r = player.xVel/2000

		-- Вертикальное ограничение
		if player.y < player.h/4 then
			player.yVel = player.yVel - (player.y-player.h/4)*100*dt
		end
		if player.y > H*0.6 then
			player.yVel = player.yVel - (player.y-H*0.6)*100*dt
		end

		-- Управление лучом
		for i, key in ipairs(player.control['beam']) do
			player.beaming = love.keyboard.isDown(key) and not player.beamOff
		end
		player.beamOff = player.beamCharge < 0
		if player.beaming then
			player.beamCharge = math.max(player.beamCharge - dt*20, -20)
			player.beamOff = player.beamCharge == -20
			if player.beamCharge <= 0 then
				player.beaming = false
			end
		else
			player.beamCharge = math.min(player.beamCharge + dt*20, 100)
		end

		for n = 1, world.ammo.count, 1 do
			if not world.ammo[n].collided and math.abs(player.x-world.ammo[n].x) < player.w/2 and math.abs(player.y-world.ammo[n].y) < player.h/2 then
				world.ammo[n].collided = true
				world.ammo[n].owner = nil
				player.hp = player.hp - 1

				world.ammo[n].xVel = -world.ammo[n].xVel*0.1
				world.ammo[n].yVel = -world.ammo[n].yVel*0.1
			end
		end

		player.screenX = math.min(math.max(player.screenX, W*0.2), W*0.8)
		player.scrolling = (player.screenX == W*0.2) or (player.screenX == W*0.8)
	end

	function player.keypressed(key)

	end
end

function player.draw()
	love.graphics.setColor(255, 255, 255)
	-- x	y	поворот	растяжение по x,y	сдвиг x,y
	player.anim:draw(math.floor(player.screenX), math.floor(player.y), player.r, 1, 1, player.w/2, player.h/2) --отрисовка по х,y и поворот в радианах

	if ui.info > 1 then
		love.graphics.setColor(205, 208, 214)
		love.graphics.setPointSize(4)
		love.graphics.setLineWidth(2)
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
