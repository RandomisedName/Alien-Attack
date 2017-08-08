world = {}

function world.load()
	world.ground = {}
	world.ground.lvl = H-60 --Высота пола
	
	world.guy = {}
	world.guy.count = 0
	world.guy.friction = 1
	
	-- Функция создания человечка
	function world.guy.add(x)
		world.guy.count = world.guy.count + 1
		world.guy[world.guy.count] = {}
		world.guy[world.guy.count].x = x
		world.guy[world.guy.count].y = world.ground.lvl
		world.guy[world.guy.count].xVel = 0
		world.guy[world.guy.count].yVel = 0
		world.guy[world.guy.count].onGround = true
		world.guy[world.guy.count].speed = love.math.random(50, 70)
		world.guy[world.guy.count].hp = 100
		--world.guy[world.guy.count].img = love.graphics.newImage()
		world.guy[world.guy.count].action = 1 --Действие 0 - стоять, Действие 2 - бежать
		--world.guy[world.guy.count].timer = 0
	end
	
	world.guy.add(love.math.random(0, W))
	world.guy.add(love.math.random(0, W))
	world.guy.add(love.math.random(0, W))
	world.guy.add(love.math.random(0, W))
end

function world.update(dt)
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
			world.guy[n].hp = world.guy[n].hp - world.guy[n].yVel
			world.guy[n].yVel = 0
			world.guy[n].y = world.ground.lvl
		end
		
		-- Выполнение действия 1 (пытаться убежать)
		if world.guy[n].action == 1 and world.guy[n].onGround then			
			if world.guy[n].x > player.x then
				world.guy[n].xVel = world.guy[n].xVel + world.guy[n].speed*dt
			else
				world.guy[n].xVel = world.guy[n].xVel - world.guy[n].speed*dt
			end
		end
		
		-- Подъем лучем
		if math.abs(player.x - world.guy[n].x) < 20 and player.beaming then
			world.guy[n].onGround = false
			world.guy[n].yVel = -40
		elseif not world.guy[n].onGround then
			world.guy[n].yVel = world.guy[n].yVel + 20*dt
		end
	end
end

function world.draw()
	if ui.info then
		love.graphics.setColor(30, 200, 30)
		love.graphics.line(0, world.ground.lvl, W, world.ground.lvl)
		
		love.graphics.setColor(255, 0, 0)
		for n = 1, world.guy.count, 1 do
			love.graphics.points(world.guy[n].x+player.screenX-player.x, world.guy[n].y)
			love.graphics.print(n..'\n'..math.floor(world.guy[n].x)..'\n'..math.floor(world.guy[n].hp), world.guy[n].x+player.screenX-player.x, world.guy[n].y)
		end
	end
end
