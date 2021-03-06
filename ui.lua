ui = {}

function ui.load()
	--Сохраняем стандартный шрифт в переменную шрифта
	ui.defaultFont = love.graphics.newFont(14)
	ui.mainFont = love.graphics.newFont('fonts/aliens and cows.ttf', 60)
	ui.alienFont = love.graphics.newFont('fonts/Sinescript.otf', 60)

	charset = {}
	for i = 97, 122 do table.insert(charset, string.char(i)) end
	for i = 65,  90 do table.insert(charset, string.char(i)) end

	ui.alienStr = charset[love.math.random(1, #charset)]..charset[love.math.random(1, #charset)]..charset[love.math.random(1, #charset)]
	ui.alienStrTimer = 0

	ui.info = 0

	ui.infoStr = {}
	ui.infoStr['left'] = ''
	ui.infoStr['center'] = ''
	ui.infoStr['right'] = ''

	function ui.addInfo(str, pos)
		if pos == nil then
			pos = 'left'
		end
		if str == nil then
			str = '\n'
		end

		ui.infoStr[pos] = ui.infoStr[pos]..str..'\n'
	end
end

function ui.update(dt)
	if ui.info > 0 then
		ui.infoStr['left'] = ''
		ui.infoStr['center'] = ''
		ui.infoStr['right'] = ''
		-- В инфо окно добавлять тут
		ui.addInfo(love.timer.getFPS())
		ui.addInfo(gamestate)
		ui.addInfo(math.floor(player.x)..'; '..math.floor(player.y)..' ('..math.floor(player.screenX)..')')
		ui.addInfo(love.mouse.getX()..'; '..love.mouse.getY())
	  ui.addInfo('HP: '..math.floor(player.hp)..' BEAM: '..math.floor(player.beamCharge))

		ui.addInfo(math.floor(world.time)..'/'..world.dayLength, 'center')

		ui.addInfo('info - f1', 'right')
		ui.addInfo('spawn guy - f2', 'right')
		ui.addInfo('pause - f10', 'right')
		ui.addInfo('relaunch - f12', 'right')
	end

	if gamestate == 'menu' then
		ui.alienStrTimer = ui.alienStrTimer - dt
		if ui.alienStrTimer <= 0 then
			ui.alienStr = string.sub(ui.alienStr, 2)
			ui.alienStr = ui.alienStr..charset[love.math.random(1, #charset)]
			ui.alienStrTimer = 0.1
		end
	end

	-- Nuklear debug window
	if nk.windowIsActive('debug') or firstLoop then
		nk.frameBegin()
		if nk.windowBegin('debug', W-310, 10, 300, H/2, 'title', 'movable', 'border', 'minimizable', 'closable', 'scrollbar') then
			nk.layoutRow('dynamic', 30, 1)
			if nk.button('restart') then
				love.event.quit('restart')
			end
			nk.layoutRow('dynamic', 30, 2)
			nk.label('volume:')
			love.audio.setVolume(nk.slider(0, love.audio.getVolume(), 1, 0.01))

			nk.layoutRow('dynamic', 140, 1)
			nk.groupBegin('Set gamestate:', 'title', 'scrollbar', 'border')
				nk.layoutRow('dynamic', 30, 2)
				for _, value in ipairs(gamestates) do
					if nk.selectable(value, gamestate == value) then
						gamestate = value
					end
				end
			nk.groupEnd()

			nk.layoutRow('dynamic', 30, 2)
			nk.label('time:')
			world.time = nk.slider(0, world.time, world.dayLength, 1)
		end
		nk.windowEnd()
		nk.frameEnd()
	end

	function ui.menu(x, y, mb)
		if gamestate == 'menu' or gamestate == 'splash' then
			if y > H*0.3 and y < H*0.3+60 and mb == 1 then
				gamestate = 'intro'
				world.music.track:stop()
				world.music.track = world.music['trashyaliens']
				world.music.track:play()
			end

			for n = 1, world.guy.count, 1 do
				if x > world.guy[n].x-world.guy.w/2 and x < world.guy[n].x+world.guy.w/2 and
				y > world.guy[n].y-world.guy.h and y < world.guy[n].y then
					world.guy[n].clicks = world.guy[n].clicks + 1
					if world.guy[n].clicks >= 20 then
						world.guy[n].hp = 0
					end
				end
			end
		end
	end

	function ui.base(key)
		if gamestate == 'menu' and key == 'return' then
			gamestate = 'intro'
			world.music.track:stop()
			world.music.track = world.music['trashyaliens']
			world.music.track:play()
		end

		if gamestate == 'splash' and (key == 'space' or key == 'return' or key == 'escape') then
			splashy.skipSplash()
			gamestate = 'menu'
		end

		if key == 'm' then
			if love.audio.getVolume() > 0 then
				love.audio.setVolume(0)
			else
				love.audio.setVolume(1)
			end
		end
	end

	function ui.func(key)
		if key == 'f1' then
			ui.info = ui.info + 1
			if ui.info > 2 then
				ui.info = 0
			end
		end
		if key == 'f2' then
			world.guy.add(love.mouse.getX()-world.offset)
		end
		if key == 'f10' then
			if gamestate == 'playing' then
				gamestate = 'pause'
			elseif gamestate == 'pause' then
				gamestate = 'playing'
			end
		end
		if key == 'f12' then
			love.event.quit('restart')
		end
	end

	function ui.keypressed(key)
		ui.base(key)
		ui.func(key)
	end

	function ui.mousepressed(x, y, mb)
		ui.menu(x, y, mb)
	end
end

function ui.draw()
	if gamestate == 'menu' then
		love.graphics.setColor(230, 230, 255)
		if love.mouse.getY() > H*0.3 and love.mouse.getY() < H*0.3+60 then
			love.graphics.setFont(ui.alienFont)
			love.graphics.printf(ui.alienStr, 0, H*0.3-20, W, 'center')
		else
			love.graphics.setFont(ui.mainFont)
			love.graphics.printf('PLAY', 0, H*0.3, W, 'center')
		end
	end

	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('fill', 0, 0, W*player.beamCharge/100, 2)

	if ui.info > 0 then
		love.graphics.setFont(ui.defaultFont)
		for n = 0, 1, 1 do
			love.graphics.setColor(255*n, 255*n, 255*n)
			for pos in pairs(ui.infoStr) do
				love.graphics.printf(ui.infoStr[pos], 10-n, 10-n, W-20, pos)
			end
		end
	end
end
