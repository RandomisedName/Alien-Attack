require('player')
require('world')
require('ui')

require('libs/anal')
splashy = require('libs/splashy')

function love.load()
	--[[
	СПИСОК ГЕЙМСТЕЙТОВ:
	splash
	menu
	intro
	playing
	pause
	]]
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
  splashy.onComplete(function() gamestate = 'menu' end)
  
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
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
		ui.mousepressed(x, y, mb)
	end

	splashy.update(dt)
end

function love.draw()
	world.draw()
	player.draw()
	ui.draw()

	splashy.draw()
end
