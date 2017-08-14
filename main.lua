require('player')
require('world')
require('ui')

require('libs/anal')
splashy = require('libs/splashy')

function love.load()
	gamestate = 'splash'
	opSys = love.system.getOS()

	origW = love.graphics.getWidth()
	origH = love.graphics.getHeight()
	W = origW
	H = origH

	world.load()
	player.load()
	ui.load()

	splashy.addSplash(love.graphics.newImage('img/love.png'), 1)
	splashy.onComplete(function() gamestate = 'playing' end)
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

	splashy.update(dt)
end

function love.draw()
	world.draw()
	player.draw()
	ui.draw()

	splashy.draw()
end
