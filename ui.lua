ui = {}

function ui.load()
	--Сохраняем стандартный шрифт в переменную шрифта
	ui.defaultFont = love.graphics.newFont(14)

	ui.info = false

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
	ui.infoStr['left'] = ''
	ui.infoStr['center'] = ''
	ui.infoStr['right'] = ''
	-- В инфо окно добавлять тут
	ui.addInfo(love.timer.getFPS())
	ui.addInfo(gamestate)
	ui.addInfo(math.floor(player.x)..'; '..math.floor(player.y)..' ('..math.floor(player.screenX)..')')
	ui.addInfo(love.mouse.getX()..'; '..love.mouse.getY())
	ui.addInfo(math.floor(world.time)..'/'..world.dayLength, 'center')

	function ui.func(key)
		if key == 'f1' then
			ui.info = not ui.info
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
			love.load()
		end
	end

	function ui.keypressed(key)
		ui.func(key)
	end
end

function ui.draw()
	if ui.info then
		love.graphics.setFont(ui.defaultFont)
		for n = 0, 1, 1 do
			love.graphics.setColor(255*n, 255*n, 255*n)
			for pos in pairs(ui.infoStr) do
				love.graphics.printf(ui.infoStr[pos], 10+n, 10+n, W-20, pos)
			end
		end
	end
end
