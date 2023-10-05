--[[
    House keeping file.
]]

-- require push librarry
push = require 'libraries/push'

-- require class library
Class = require 'libraries/class'

-- require knife library
Timer = require 'libraries/knife.timer'

-- utilities (sprite getter)
require 'source/Utilities'

-- global variables
require 'source/Globals'

-- state machine
require 'source/SM'
require 'source/states/Base'
require 'source/states/Start'
require 'source/states/Play'
require 'source/states/GameOver'

-- generate world
require 'source/GenerateWorld'

-- generate beach
require 'source/GenerateBeach'

-- generate river
require 'source/GenerateRiver'

-- player
require 'source/player_def'
require 'source/Player'
require 'source/states/player/PlayerWalk'
require 'source/states/player/PlayerIdle'
require 'source/states/player/PlayerCasting'
require 'source/states/player/PlayerFishing'
require 'source/states/player/PlayerShop'
require 'source/states/player/PlayerInventory'
require 'source/states/player/PlayerAchievement'
require 'source/states/player/PlayerFight'

-- enemies
require 'source/Enemies'
require 'source/states/enemies/EnemiesWalk'
require 'source/states/enemies/EnemiesIdle'

-- fish catching functions
require 'source/CatchFish'


-- Sprite Sheets Alphabetical
SpriteSheet = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['beach'] = love.graphics.newImage('graphics/beach.png'),
    ['enemies'] = love.graphics.newImage('graphics/enemies.png'),
    ['fish'] = love.graphics.newImage('graphics/fish.png'),
    ['ground'] = love.graphics.newImage('graphics/ground.png'),
    ['inventory'] = love.graphics.newImage('graphics/inventory.png'),
    ['shop'] = love.graphics.newImage('graphics/shop.png'),
    ['shop_background'] = love.graphics.newImage('graphics/shop_background.png'),
    ['title'] = love.graphics.newImage('graphics/start.png')
}

-- Individual Sprites Alphabetical
Sprites = {
    ['beach'] = GetBeach(SpriteSheet['beach']),
    ['big_fish'] = GetBigFish(SpriteSheet['fish']),
    ['enemies'] = GetEnemies(SpriteSheet['enemies']),
    ['ground'] = GetGround(SpriteSheet['ground']),
    ['ground_path'] = GetGroundPath(SpriteSheet['ground']),
    ['hearts'] = GetHearts(SpriteSheet['fish']),
    ['inventory'] = GetInventory(SpriteSheet['inventory']),
    ['items'] = GetItems(SpriteSheet['fish']),
    ['player'] = GetPlayer(SpriteSheet['fish']),
    ['shop_items'] = GetShop(SpriteSheet['shop']),
    ['signs'] = GetSigns(SpriteSheet['ground']),
    ['small_fish'] = GetSmallFish(SpriteSheet['fish']),
    ['title'] = GetTitle(SpriteSheet['title']),
    ['wall'] = GetWall(SpriteSheet['ground']),
    ['wall_ground'] = GetWallGround(SpriteSheet['ground']),
    ['water'] = GetWater(SpriteSheet['ground'])
}

-- Fonts
Fonts = {
    ['x-sm'] = love.graphics.newFont('fonts/RetroscapeRegular.ttf', 8),
    ['sm'] = love.graphics.newFont('fonts/RetroscapeRegular.ttf', 16),
    ['md'] = love.graphics.newFont('fonts/RetroscapeRegular.ttf', 32),
    ['lg'] = love.graphics.newFont('fonts/RetroscapeRegular.ttf', 48),
    ['x-lg'] = love.graphics.newFont('fonts/RetroscapeRegular.ttf', 64),
    ['xx-lg'] = love.graphics.newFont('fonts/RetroscapeRegular.ttf', 128)
}

-- Sounds Alphabetical
Sounds = {
    ['background'] = love.audio.newSource('sounds/piano.wav', 'static'),
    ['cast'] = love.audio.newSource('sounds/cast.wav', 'static'),
    ['cast_power'] = love.audio.newSource('sounds/cast_power.wav', 'static'),
    ['fish_off'] = love.audio.newSource('sounds/fish_off.wav', 'static'),
    ['fish_on'] = love.audio.newSource('sounds/fish_on.wav', 'static'),
    ['get_money'] = love.audio.newSource('sounds/get_money.wav', 'static'),
    ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
    ['new_fish'] = love.audio.newSource('sounds/new_fish.wav', 'static'),
    ['old_fish'] = love.audio.newSource('sounds/old_fish.wav', 'static'),
    ['squish'] = love.audio.newSource('sounds/squish.wav', 'static'),
    ['sword'] = love.audio.newSource('sounds/sword.wav', 'static'),
    ['sword_hit'] = love.audio.newSource('sounds/sword_hit.wav', 'static'),
    ['walk'] = love.audio.newSource('sounds/walk.wav', 'static'), 
}

-- Set Sound Volumes
Sounds['get_money']:setVolume(0.5)
Sounds['hurt']:setVolume(0.5)
Sounds['new_fish']:setVolume(0.5)