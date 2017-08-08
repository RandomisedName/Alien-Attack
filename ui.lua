ui = {}

function ui.load()
	--Сохраняем стандартный шрифт в переменную шрифта
	ui.defaultFont = love.graphics.newFont(14)
	
	ui.info = true
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
		love.graphics.setColor(0, 175, 255)
		love.graphics.setFont(ui.defaultFont)
		love.graphics.printf(love.timer.getFPS()..'\n'..math.floor(player.x)..'; '..math.floor(player.y)..' ('..math.floor(player.screenX)..')'..'\n'..love.mouse.getX()..'; '..love.mouse.getY(), 10, 10, W-20, 'left')
	end
end
