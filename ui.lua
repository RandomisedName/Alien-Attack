ui = {}

function ui.load()
	--Сохраняем стандартный шрифт в переменную шрифта
	ui.defaultFont = love.graphics.newFont(14)

	ui.info = false
end

function ui.update(dt)
	function ui.func(key)
		if key == 'f1' then
			ui.info = not ui.info
		end
	end

	function ui.keypressed(key)
		ui.func(key)
	end
end

function ui.draw()
	if ui.info then
		love.graphics.setFont(ui.defaultFont)
		love.graphics.setColor(0, 0, 0)
		love.graphics.printf(love.timer.getFPS()..'\n'..math.floor(player.x)..'; '..math.floor(player.y)..' ('..math.floor(player.screenX)..')'..'\n'..love.mouse.getX()..'; '..love.mouse.getY(), 11, 11, W-20, 'left')
		love.graphics.setColor(255, 255, 255)
		love.graphics.printf(love.timer.getFPS()..'\n'..math.floor(player.x)..'; '..math.floor(player.y)..' ('..math.floor(player.screenX)..')'..'\n'..love.mouse.getX()..'; '..love.mouse.getY(), 10, 10, W-20, 'left')
	end
end
