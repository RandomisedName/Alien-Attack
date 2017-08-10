world = {}

function world.load()
	world.ground = {}
	world.ground.lvl = H-60 --Высота пола

	world.guy = {}
	world.guy.count = 0
	world.guy.friction = 1
	world.guy.g = 80

	-- Функция создания человечка
	function world.guy.add(x)
		world.guy.count = world.guy.count + 1
		world.guy[world.guy.count] = {}
		world.guy[world.guy.count].x = x
		world.guy[world.guy.count].y = world.ground.lvl
		world.guy[world.guy.count].xVel = 0
		world.guy[world.guy.count].yVel = 0
		world.guy[world.guy.count].dir = 1
		world.guy[world.guy.count].onGround = true
		world.guy[world.guy.count].speed = love.math.random(50, 70)
		world.guy[world.guy.count].hp = 100
		--world.guy[world.guy.count].img = love.graphics.newImage()
		world.guy[world.guy.count].action = 1 --Действие 0 - стоять, Действие 2 - бежать
		--world.guy[world.guy.count].timer = 0
	end

	for n = 1, 10, 1 do
		world.guy.add(love.math.random(-W, W*2))
	end

	world.lexa = {}
	world.lexa.runSheet = love.graphics.newImage("img/world/alex.png")
	world.lexa.idleSheet=love.graphics.newImage("img/world/alexdm.png")
	world.lexa.dead=love.graphics.newImage("img/world/mogila.png")
	world.lexa.h = world.lexa.runSheet:getHeight()
	world.lexa.w = world.lexa.runSheet:getWidth() / 4
	world.lexa.mogilaH = world.lexa.dead:getHeight()
	world.lexa.mogilaW = world.lexa.dead:getWidth()
	world.lexa.run = newAnimation(world.lexa.runSheet,70,100,0.23,4)
	world.lexa.idle = newAnimation(world.lexa.idleSheet,70,100,1,1)
	world.lexa.run:play()
	world.lexa.idle:play()
end

function world.update(dt)
	world.lexa.run:update(dt)
	world.lexa.idle:update(dt)
	-- Обработка человечков
	for n = 1, world.guy.count, 1 do
		--[[world.guy[n].timer = world.guy[n].timer - dt
		if world.guy[n].timer <= 0 then --При достижении 0 таймер обновляется и дает новое действие
			world.guy[n].action = love.math.random(0, 1)
			world.guy[n].timer = love.math.random(2, 6)*world.guy[n].action + love.math.random(5, 15)/10
		end
		if math.abs(player.x - world.guy[n].x) > W*1.5 then
			world.guy[n].action = 0
		end]]

		-- Остановка, когда уходят слишком далеко
		if math.abs(player.x - world.guy[n].x) > W*1.5 then
			world.guy[n].xVel = 0
		end

		world.guy[n].x = world.guy[n].x + world.guy[n].xVel*dt
		world.guy[n].y = world.guy[n].y + world.guy[n].yVel*dt
		world.guy[n].xVel = world.guy[n].xVel * (1 - math.min(world.guy.friction*dt, 1))

		-- Проверка на столкновение с землей
		if not world.guy[n].onGround and world.guy[n].y >= world.ground.lvl then
			world.guy[n].onGround = true
			world.guy[n].hp = world.guy[n].hp - world.guy[n].yVel/3
			world.guy[n].yVel = 0
			world.guy[n].y = world.ground.lvl
		end

		-- Выполнение действия 1 (пытаться убежать)
		if world.guy[n].action == 1 and world.guy[n].onGround and world.guy[n].hp > 0 then
			if world.guy[n].x > player.x then
				world.guy[n].xVel = world.guy[n].xVel + world.guy[n].speed*dt
				world.guy[n].dir = 1
			else
				world.guy[n].xVel = world.guy[n].xVel - world.guy[n].speed*dt
				world.guy[n].dir = -1
			end
		end

		-- Подъем лучем
		if math.abs(player.x - world.guy[n].x) < 20 and player.beaming then
			world.guy[n].onGround = false
			world.guy[n].yVel = -40
		elseif not world.guy[n].onGround then
			world.guy[n].yVel = world.guy[n].yVel + world.guy.g*dt
		end
	end
end

function world.draw()
	love.graphics.setColor(114, 173, 255)
	love.graphics.rectangle('fill', 0, 0, W, H)

	love.graphics.setColor(255, 255, 255)

	for n = 1, world.guy.count, 1 do
		if 	world.guy[n].hp >  0 then
			if world.guy[n].onGround then
				world.lexa.run:draw(math.floor(world.guy[n].x+player.screenX-player.x),math.floor(world.guy[n].y), 0, 0.33*world.guy[n].dir, 0.33, world.lexa.w / 4, world.lexa.h )
			else
				world.lexa.idle:draw(math.floor(world.guy[n].x+player.screenX-player.x),math.floor(world.guy[n].y), 0, 0.33*world.guy[n].dir, 0.33, world.lexa.w / 4, world.lexa.h )
			end
		else
			love.graphics.draw(world.lexa.dead, math.floor(world.guy[n].x+player.screenX-player.x),math.floor(world.guy[n].y), 0, 1.25, 1.25, world.lexa.mogilaW / 2, world.lexa.mogilaH)
		end
	end

	if ui.info then
		love.graphics.setColor(30, 200, 30)
		love.graphics.line(0, world.ground.lvl, W, world.ground.lvl)

		for n = 1, world.guy.count, 1 do
			love.graphics.setColor(255, 0, 0)
			love.graphics.points(world.guy[n].x+player.screenX-player.x, world.guy[n].y)
			love.graphics.print(n..'\n'..math.floor(world.guy[n].x)..'\n'..math.floor(world.guy[n].hp), world.guy[n].x+player.screenX-player.x, world.guy[n].y)
		end
	end
end
