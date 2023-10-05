-- GAME WIDTH AND HEIGHT
GAME_WIDTH = 640
GAME_HEIGHT = 352

-- WINDOW WIDTH AND HEIGHT
WIDTH = 1280
HEIGHT = 720

-- Walls
TOP_WALL = {3, 4, 5}
BOTTOM_WALL = {10, 11, 12}
LEFT_WALL = {1, 8}
RIGHT_WALL = {2, 9}

-- Wall Corners top-left, top-right, botton-left, bottom-right
WALL_CORNER = {6, 7, 13, 14}

-- Wall Connected to Ground
TOP_LEFT_CORNER = 1
TOP_MIDDLE = 2
TOP_RIGHT_CORNER = 3
BOTTOM_LEFT_CORNER = 5
BOTTOM_MIDDLE = 6
BOTTOM_RIGHT_CORNER = 7
RIGHT_MIDDLE = 4
LEFT_MIDDLE = 8

-- Beach Tiles
BEACH_GROUND = {1, 2} -- blank, rough
BEACH_WALL = {3, 4, 5, 6} -- left wall 1, left wall 2, right wall 1, right wall 2
BEACH_PATH = {7, 8, 9, 10, 11, 12} -- top left edge, bottom left edge, top middle, bottom middle, top right edge, bottom right edge
BEACH_CORNERS = {13, 14, 15, 16} -- top left, bottom left, top right, bottom right
BEACH_ROUGH_CORNERS = {17, 18 ,19, 20} -- top left, bottom left, top right, bottom right
BEACH_EDGE = {21, 23, 25} -- bottom, top, right
BEACH_ROUGH_EDGE = {22, 24, 26} -- bottom, top, right


-- Small Fish
SMALL_FISH_1 = {1, 2, 3, 4}
SMALL_FISH_2 = {5, 6, 7, 8}
SMALL_FISH_3 = {9, 10, 11, 12}
SMALL_FISH_4 = {13, 14, 15, 16}

-- Big Fish
BIG_FISH_1 = {1, 2, 3, 4}
BIG_FISH_2 = {5, 6, 7, 8}
BIG_FISH_3 = {9, 10, 11, 12}
BIG_FISH_4 = {13, 14, 15, 16}

-- Player Animations
PLAYER_UP = {1, 2, 3, 4}
PLAYER_DOWN = {5, 6, 7, 8}
PLAYER_LEFT = {9, 10, 11, 12}
PLAYER_RIGHT = {13, 14, 15, 16}

-- Player Idle
PLAYER_IDLE_UP = 4
PLAYER_IDLE_DOWN = 8
PLAYER_IDLE_LEFT = 12
PLAYER_IDLE_RIGHT = 16

-- Player Fishing
PLAYER_FISH_UP = 18
PLAYER_FISH_DOWN = 20
PLAYER_FISH_LEFT = 22
PLAYER_FISH_RIGHT = 24

-- Pole Tip Offset{x, y}
POLE_TIP_UP = {32, 21}
POLE_TIP_DOWN = {50, 63}
POLE_TIP_LEFT = {3, 22}
POLE_TIP_RIGHT = {62, 21}

-- Player Casting
PLAYER_CAST_UP = 17
PLAYER_CAST_DOWN = 19
PLAYER_CAST_LEFT = 21
PLAYER_CAST_RIGHT = 23

-- Player Fighting
FIGHT_UP = {25, 26}
FIGHT_IDLE_UP = 25
FIGHT_DOWN = {27, 28}
FIGHT_IDLE_DOWN = 27
FIGHT_LEFT = {29, 30}
FIGHT_IDLE_LEFT = 29
FIGHT_RIGHT = {31, 32}
FIGHT_IDLE_RIGHT = 31

PLAYER_WALK_SPEED = 140

-- Number needed to reel fish in
CATCH = 100
BREAK = 100

-- Top of water
WATER_TOP = GAME_HEIGHT / 2

-- Enemies
-- Purple
PURP_IDLE_DOWN = 1
PURP_DOWN = {1, 2, 3}
PURP_IDLE_UP = 4
PURP_UP = {4, 5, 6}
PURP_IDLE_RIGHT = 7
PURP_RIGHT = {7, 8, 9}
PURP_IDLE_LEFT = 10
PURP_LEFT = {10, 11, 12}
-- Blue
BLUE_IDLE_DOWN = 13
BLUE_DOWN = {13, 14, 15}
BLUE_IDLE_UP = 16
BLUE_UP = {16, 17, 18}
BLUE_IDLE_RIGHT = 19
BLUE_RIGHT = {19, 20, 21}
BLUE_IDLE_LEFT = 22
BLUE_LEFT = {22, 23, 24}
-- Green
GREEN_IDLE_DOWN = 25
GREEN_DOWN = {25, 26, 27}
GREEN_IDLE_UP = 28
GREEN_UP = {28, 29, 30}
GREEN_IDLE_RIGHT = 31
GREEN_RIGHT = {31, 32, 33}
GREEN_IDLE_LEFT = 34
GREEN_LEFT = {34, 35, 36}
-- Direction
ENEMY_DIRECTION = {'left', 'right', 'up', 'down'}
-- walk speen
ENEMIES_WALK_SPEED = 80

-- day/night cycle
CYCLE = 120