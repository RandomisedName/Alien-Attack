require('player')
require('world')
require('ui')

require('anal')

function love.load()
	gamestate = 'playing'
	opSys = love.system.getOS()

	origW = love.graphics.getWidth()
	origH = love.graphics.getHeight()
	W = origW
	H = origH

	world.load()
	player.load()
	ui.load()
end

function love.update(dt)
	world.update(dt)
	player.update(dt)
	ui.update(dt)

	function love.keypressed(key)
		ui.keypressed(key)
		player.keypressed(key)
	end

	function love.mousepressed(x, y, mb)

	end
end

function love.draw()
	world.draw()
	player.draw()
	ui.draw()
end
