--[[
    Fishing

    Author: Chase Holland
    chase.holland@yahoo.com

]]

require 'source/Dependancies'

function love.load()

    -- set window title
    love.window.setTitle('Fishing')

    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed the rng with os.time
    math.randomseed(os.time())

    -- set up screen
    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WIDTH, HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    -- set up state machine
    gameSM = SM {
        ['start'] = function() return Start() end,
        ['play'] = function() return Play() end,
        ['game-over'] = function() return GameOver() end
    }
    gameSM:change('start')

    -- table to keep track of user input
    love.keyboard.keysPressed = {}

    -- keep track of mouse input
    love.mouse.wasPressed = {}

    love.mouse.wheelmoved = ''

    Sounds['background']:setVolume(.5)
    Sounds['background']:setLooping(true)
    Sounds['background']:play()

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.pressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.mousepressed(x, y, key)
    love.mouse.wasPressed[key] = true
end

function love.mouse.pressed(key)
    return love.mouse.wasPressed[key]
end

function love.wheelmoved(x, y)
    if y > 0 then
        love.mouse.wheelmoved = 'up'
    elseif y < 0 then
        love.mouse.wheelmoved = 'down'
    end
end

function love.update(dt)

    -- get relative mouse coordinates
    mouseX, mouseY = push:toGame(love.mouse.getX(), love.mouse.getY())
    if mouseX then
        mouseX = math.floor(mouseX)
    end
    if mouseY then
        mouseY = math.floor(mouseY)
    end

    Timer.update(dt)

    -- update state machine
    gameSM:update(dt)

    -- empty input table
    love.keyboard.keysPressed = {}
    love.mouse.wasPressed = {}
    love.mouse.wheelmoved = ''

end

function love.draw()

    push:start()

    love.graphics.draw(SpriteSheet['shop_background'])

    -- render from state machine
    gameSM:render()

    push:finish()

end