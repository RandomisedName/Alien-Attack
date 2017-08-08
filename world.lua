world = {}

function world.load()
	world.ground = {}
	world.ground.lvl = H-60
end

function world.update(dt)
	
end

function world.draw()
	if ui.info then
		love.graphics.setColor(30, 200, 30)
		love.graphics.line(0, world.ground.lvl, W, world.ground.lvl)
	end
end
