world = {}

function world.load()
	world.time = 0
	world.dayLength = 60

	world.offset = 0

	world.g = 90

	world.ground = {}
	world.ground.lvl = H-60 --Высота пола

	world.bg = {}
	world.bg.img = love.graphics.newImage("img/world/city.png")
	world.bg.imgMask = love.graphics.newImage("img/world/citymask.png")
	world.bg.imgGlow = love.graphics.newImage("img/world/cityglow.png")
	world.bg.imgGlowH = world.bg.imgGlow:getHeight()
	world.bg.w = world.bg.img:getWidth()
	world.bg.h = world.bg.img:getHeight()
	world.bg.count = 5
	world.bg.parallax = 3 -- Фактор параллакса
	world.bg.lightCount = 1000
	for n = 0, world.bg.count, 1 do
		world.bg[n] = {}
		world.bg[n].x = world.bg.w*n
		world.bg[n].light = {}
		for m = 0, world.bg.lightCount, 1 do
			world.bg[n].light[m] = {}
			world.bg[n].light[m].x = love.math.random(2, world.bg.w-2)
			world.bg[n].light[m].y = love.math.random(2, world.bg.h-5)
			world.bg[n].light[m].time = love.math.random(10, world.dayLength/4*10)/10 --Эмперический знаменатель! (4)
		end
	end

	world.bg.sun = love.graphics.newImage('img/world/sun.png')
	world.bg.sunH = world.bg.sun:getHeight()
	world.bg.finalClr = {114, 173, 255}
	world.bg.clr = {0, 0, 0}

	world.music = {}
	world.music['trashyaliens'] = love.audio.newSource('audio/trashyaliens.mp3', 'stream')
	world.music['trashyaliens']:setLooping(true)
	world.music['cyberdreamloop'] = love.audio.newSource('audio/cyberdreamloop.mp3', 'stream')
	world.music['cyberdreamloop']:setLooping(true)
	world.music.track = world.music['cyberdreamloop']
	world.music.track:play()

	world.effect = {}
	world.effect['dayend'] = love.audio.newSource('audio/dayend.mp3')

	world.guy = {}
	world.guy.count = 0
	world.guy.friction = 1

	world.guy.runSheet = love.graphics.newImage("img/world/alex.png")
	world.guy.idleImg = love.graphics.newImage("img/world/alexidle.png")
	world.guy.deadImg = love.graphics.newImage("img/world/alexdead.png")
	world.guy.h = world.guy.runSheet:getHeight()
	world.guy.w = world.guy.runSheet:getWidth() / 4
	world.guy.deadW = world.guy.deadImg:getWidth()
	world.guy.deadH = world.guy.deadImg:getHeight()

	-- Функция создания человечка
	function world.guy.add(x)
		world.guy.count = world.guy.count + 1
		world.guy[world.guy.count] = {}
		world.guy[world.guy.count].x = x
		world.guy[world.guy.count].y = world.ground.lvl
		world.guy[world.guy.count].xVel = 0
		world.guy[world.guy.count].yVel = 0
		world.guy[world.guy.count].dir = 0
		while (world.guy[world.guy.count].dir == 0) do
			world.guy[world.guy.count].dir = love.math.random(-1, 1)
		end
		world.guy[world.guy.count].onGround = true
		world.guy[world.guy.count].speed = love.math.random(50, 70)
		world.guy[world.guy.count].strength = love.math.random(300, 400)
		world.guy[world.guy.count].hp = 100
		world.guy[world.guy.count].action = -1 --Действие -1 - бродить, Действие 0 - атака, Действие 1 - бездействие, Действие 2 - бежать,
		world.guy[world.guy.count].timer = love.math.random(5, 10)
		world.guy[world.guy.count].clicks = 0

		world.guy[world.guy.count].runAnim = newAnimation(world.guy.runSheet, 23, 33, 0.23, 4)

		world.guy[world.guy.count].runAnim:play()
	end

	for n = 1, 100, 1 do
		world.guy.add(love.math.random(-W, W*2))
	end

	world.ammo = {}
	world.ammo.count = 0
end

function world.update(dt)
	if gamestate == 'playing' then
		world.time = math.min(world.time + dt, world.dayLength)
	end

	if gamestate == 'playing' or gamestate == 'menu' or gamestate == 'intro' or gamestate == 'splash' then
		world.offset = player.screenX-player.x

		if world.time > world.dayLength*0.8 then
			world.music.track:setPitch(1+((world.time-world.dayLength*0.8)/world.dayLength*4))
		end
		if world.time >= world.dayLength then
			gamestate = 'dayend'
			world.music.track:stop()
			world.effect['dayend']:play()
			player.beamSound:setVolume(0)
		end

		for n = 1, 3, 1 do
			world.bg.clr[n] = world.time/world.dayLength*world.bg.finalClr[n]
		end

		-- Обработка человечков --
		for n = 1, world.guy.count, 1 do
			world.guy[n].onScreen = (world.guy[n].x+world.offset>0) and (world.guy[n].x+world.offset<W)

			world.guy[n].x = world.guy[n].x + world.guy[n].xVel*dt
			world.guy[n].y = world.guy[n].y + world.guy[n].yVel*dt
			world.guy[n].xVel = world.guy[n].xVel * (1 - math.min(world.guy.friction*dt, 1))

			-- Проверка на столкновение с землей
			if not world.guy[n].onGround and world.guy[n].y >= world.ground.lvl then
				if world.guy[n].hp > 0 and world.guy[n].yVel > 100 then
					world.guy[n].hp = world.guy[n].hp - world.guy[n].yVel/3
				end
				world.guy[n].onGround = true
				world.guy[n].yVel = 0
				world.guy[n].y = world.ground.lvl
			end

			if world.guy[n].hp > 0 then
				world.guy[n].timer = world.guy[n].timer - dt
				if world.guy[n].timer <= 0 then --При достижении 0 таймер обновляется и дает новое действие
					if world.guy[n].action == -1 then
						world.guy[n].action = -1
						world.guy[n].dir = -world.guy[n].dir
						world.guy[n].timer = love.math.random(5, 10)
					elseif world.guy[n].action == 1 then
						world.guy[n].action = 0
						world.guy[n].timer = love.math.random(5, 10)/10
					else
						world.guy[n].action = love.math.random(1, 2)
						world.guy[n].timer = love.math.random(15, 40)/10
					end
				end
				if math.abs(player.x - world.guy[n].x) > W*1.5 then
					world.guy[n].action = 0
				end

				-- Остановка, когда уходят слишком далеко
				if math.abs(player.x - world.guy[n].x) > W*1.5 then
					world.guy[n].xVel = 0
				end

				-- Действия
				if world.guy[n].action == -1 then
					world.guy[n].xVel = world.guy[n].xVel - world.guy[n].speed/2*-world.guy[n].dir*dt
					world.guy[n].runAnim:update(dt)
					world.guy[n].runAnim:setSpeed(0.5) -- Лучше вызывать 1 раз
				elseif world.guy[n].action == 0 then -- Выполнение действия 0 (атака)
					if world.guy[n].onScreen then
						world.guy[n].action = 2

						world.ammo.count = world.ammo.count + 1
						world.ammo[world.ammo.count] = {}
						world.ammo[world.ammo.count].active = true
						world.ammo[world.ammo.count].collided = false
						world.ammo[world.ammo.count].type = 'rock'
						world.ammo[world.ammo.count].owner = n
						world.ammo[world.ammo.count].x = world.guy[n].x
						world.ammo[world.ammo.count].y = world.guy[n].y
						world.ammo[world.ammo.count].vel = ((player.x -  world.guy[n].x)^2+(player.y -  world.guy[n].y)^2)^0.5
						world.ammo[world.ammo.count].xVel = (player.x -  world.guy[n].x)/world.ammo[world.ammo.count].vel*world.guy[n].strength
						world.ammo[world.ammo.count].yVel = (player.y -  world.guy[n].y)/world.ammo[world.ammo.count].vel*world.guy[n].strength
					end

					if world.guy[n].x > player.x then
						world.guy[n].dir = -1
					else
						world.guy[n].dir = 1
					end
				elseif world.guy[n].action == 1 then
					if world.guy[n].x > player.x then
						world.guy[n].dir = -1
					else
						world.guy[n].dir = 1
					end
				elseif world.guy[n].action == 2 and world.guy[n].onGround then -- Выполнение действия 2 (пытаться убежать)
					world.guy[n].runAnim:update(dt)
					world.guy[n].runAnim:setSpeed(1) -- Лучше вызывать 1 раз
					if world.guy[n].x > player.x then
						world.guy[n].xVel = world.guy[n].xVel + world.guy[n].speed*dt
						world.guy[n].dir = 1
					else
						world.guy[n].xVel = world.guy[n].xVel - world.guy[n].speed*dt
						world.guy[n].dir = -1
					end
				end

				-- Попадание снаряда
				for m = 1, world.ammo.count, 1 do
					if world.ammo[m].active and world.guy[n].onGround and math.abs(world.guy[n].x - world.ammo[m].x) < world.guy.w/2 and math.abs(world.guy[n].y - world.ammo[m].y) < world.guy.h/2 and world.ammo[m].owner ~= n then
						world.guy[n].hp = world.guy[n].hp - world.ammo[m].vel/30

						world.ammo[m].active = false
						world.ammo[m].xVel = 0
						world.ammo[m].yVel = 0
						world.ammo[m].y = love.math.random(world.ground.lvl, world.ground.lvl+5)
					end
				end
			end

			-- Подъем лучем
			if math.abs(player.x - world.guy[n].x) < 20 and player.beaming then
				world.guy[n].onGround = false
				world.guy[n].yVel = -player.beamSpeed
			elseif not world.guy[n].onGround then
				world.guy[n].yVel = world.guy[n].yVel + world.g*dt
			end
		end

		-- Движение фона
		for n = 0, world.bg.count, 1 do
			if world.bg[n].x+world.offset/world.bg.parallax > W then
				if n < world.bg.count then
					world.bg[n].x = world.bg[n+1].x - world.bg.w
				else
					world.bg[n].x = world.bg[0].x - world.bg.w
				end
			end

			if world.bg[n].x+world.offset/world.bg.parallax+world.bg.w < 0 then
				if n > 0 then
					world.bg[n].x = world.bg[n-1].x + world.bg.w
				else
					world.bg[n].x = world.bg[world.bg.count].x + world.bg.w
				end
			end
		end

		-- Обработка снарядов --
		for n = 1, world.ammo.count, 1 do
			world.ammo[n].vel = ((world.ammo[n].xVel^2)+(world.ammo[n].yVel^2))^0.5

			if math.abs(player.x - world.ammo[n].x) < 20 and player.beaming then
				world.ammo[n].active = true
				world.ammo[n].xVel = 0
				world.ammo[n].yVel = -player.beamSpeed
				if world.ammo[n].y > world.ground.lvl then
					 world.ammo[n].y = world.ground.lvl
				end
			end

			if world.ammo[n].active then
				world.ammo[n].yVel = world.ammo[n].yVel + world.g*dt
				world.ammo[n].x = world.ammo[n].x + world.ammo[n].xVel*dt
				world.ammo[n].y = world.ammo[n].y + world.ammo[n].yVel*dt

				if world.ammo[n].y > world.ground.lvl then
					world.ammo[n].active = false
					world.ammo[n].xVel = 0
					world.ammo[n].yVel = 0
					world.ammo[n].y = love.math.random(world.ground.lvl, world.ground.lvl+5)
				end
			end
		end
	end
end

function world.draw()
	love.graphics.setColor(world.bg.clr)
	love.graphics.rectangle('fill', 0, 0, W, H)

	-- Солнце
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(world.bg.sun, 0, world.ground.lvl-world.time/world.dayLength*world.bg.sunH*0.7)

	-- Фоновый ландшафт
	for n = 0, world.bg.count, 1 do
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(world.bg.img, math.floor(world.bg[n].x+world.offset/world.bg.parallax), math.floor(world.ground.lvl-world.bg.h-(player.y-H*0.6)/50+1)) -- "+1" Нужно, поскольку тарелка проваливается вниз за границу

		-- Окошки
		if world.time < world.dayLength/4 then --Эмперический знаменатель! (4)
			love.graphics.setColor(255, 249, 186)
			love.graphics.setPointSize(2)
			for m = 1, world.bg.lightCount, 1 do
				if world.time < world.bg[n].light[m].time then
					love.graphics.points(math.floor(world.bg[n].x+world.offset/world.bg.parallax+world.bg[n].light[m].x), world.ground.lvl-world.bg.h-(player.y-H*0.6)/50+world.bg[n].light[m].y)
				end
			end

			love.graphics.setColor(world.bg.clr)
			love.graphics.draw(world.bg.imgMask, math.floor(world.bg[n].x+world.offset/world.bg.parallax), math.floor(world.ground.lvl-world.bg.h-(player.y-H*0.6)/50+1)) -- "+1" Нужно, поскольку тарелка проваливается вниз за границу
		end
	end
	love.graphics.setColor(255, 249, 186, math.max(255-255*world.time/world.dayLength*4, 0))
	love.graphics.draw(world.bg.imgGlow, 0, math.floor(world.ground.lvl-world.bg.imgGlowH-(player.y-H*0.6)/50+1))

	love.graphics.setColor(163, 255, 135)
	love.graphics.rectangle('fill', 0, world.ground.lvl, W, H-world.ground.lvl)
	love.graphics.setColor(100, 100, 100)
	love.graphics.setLineWidth(3)
	love.graphics.setLineStyle('rough')
	love.graphics.line(0, world.ground.lvl, W, world.ground.lvl)

	love.graphics.setColor(255, 255, 255)
	-- Отрисовка человечков --
	for n = 1, world.guy.count, 1 do
		if 	world.guy[n].hp >  0 then
			if world.guy[n].onGround then
				if world.guy[n].action == 2 or world.guy[n].action == -1 then
					world.guy[n].runAnim:draw(math.floor(world.guy[n].x+world.offset),math.floor(world.guy[n].y), 0, world.guy[n].dir, 1, world.guy.w/2, world.guy.h)
				else
					love.graphics.draw(world.guy.idleImg, math.floor(world.guy[n].x+world.offset),math.floor(world.guy[n].y), 0, 1*world.guy[n].dir, 1, world.guy.w/2, world.guy.h)
				end
			else
				love.graphics.draw(world.guy.idleImg, math.floor(world.guy[n].x+world.offset),math.floor(world.guy[n].y), 0, 1*world.guy[n].dir, 1, world.guy.w/2, world.guy.h)
			end
		else
			love.graphics.draw(world.guy.deadImg, math.floor(world.guy[n].x+world.offset),math.floor(world.guy[n].y), 0, 1, 1, world.guy.deadW/2, world.guy.deadH)
		end
	end

	-- Отрисовка снарядов --
	for n = 1, world.ammo.count, 1 do
		if world.ammo[n].type == 'rock' then
			love.graphics.setColor(100, 100, 100)
			love.graphics.setPointSize(4)
			love.graphics.points(world.ammo[n].x+world.offset, world.ammo[n].y)
		end
	end

	if ui.info > 1 then
		love.graphics.setLineWidth(3)
		for n = 1, world.guy.count, 1 do
			love.graphics.setColor(255, 0, 0)
			love.graphics.setPointSize(2)
			love.graphics.points(world.guy[n].x+world.offset, world.guy[n].y)
			love.graphics.print(world.guy[n].action, world.guy[n].x+world.offset, world.guy[n].y)
			love.graphics.setColor(255, 255, 255)
			love.graphics.line(world.guy[n].x+world.offset-world.guy.w/2, world.guy[n].y - world.guy.h*1.2, world.guy[n].x+world.offset+world.guy.w/2, world.guy[n].y - world.guy.h*1.2)
			love.graphics.setColor(255, 0, 0)
			love.graphics.line(world.guy[n].x+world.offset-world.guy.w/2, world.guy[n].y - world.guy.h*1.2, world.guy[n].x+world.offset-world.guy.w/2+math.max(world.guy.w*world.guy[n].hp/100, 0), world.guy[n].y - world.guy.h*1.2)
		end
	end
end
