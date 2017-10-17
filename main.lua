require('player')
require('world')
require('ui')

require('libs/anal')
splashy = require('libs/splashy')
nk = require 'nuklear'

function love.load()
	nk.init()

	-- СПИСОК ГЕЙМСТЕЙТОВ:
	gamestates = {
		'splash',
		'menu',
		'intro',
		'playing',
		'pause'
	}
	gamestate = 'splash'
	opSys = love.system.getOS()
	firstLoop = true

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

	function love.keypressed(key, scancode, isrepeat)
		ui.keypressed(key)
		player.keypressed(key)

		nk.keypressed(key, scancode, isrepeat)
	end

	function love.mousepressed(x, y, mb, istouch)
		ui.mousepressed(x, y, mb)

		nk.mousepressed(x, y, mb, istouch)
	end

	function love.keyreleased(key, scancode)
		nk.keyreleased(key, scancode)
	end

	function love.mousereleased(x, y, button, istouch)
		nk.mousereleased(x, y, button, istouch)
	end

	function love.mousemoved(x, y, dx, dy, istouch)
		nk.mousemoved(x, y, dx, dy, istouch)
	end

	function love.textinput(text)
		nk.textinput(text)
	end

	function love.wheelmoved(x, y)
		nk.wheelmoved(x, y)
	end

	splashy.update(dt)

	if firstLoop then
		firstLoop = false
	end
end

function love.draw()
	world.draw()
	player.draw()
	ui.draw()

	nk.draw()

	splashy.draw()
end
