require('player')
require('world')
require('ui')

function love.load()
	world.load()
	player.load()
	ui.load()
end

function love.update(dt)
	world.update(dt)
	player.update(dt)
	ui.update(dt)
	
	function love.keypressed(key)
		
	end
	
	function love.mousepressed(x, y, mb)
		
	end
end

function love.draw()
	world.draw()
	player.draw()
	ui.draw()
end