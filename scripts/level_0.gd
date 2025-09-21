extends Node2D
signal level_changed(level_name)
@export () var level_name = ""

const TILE_SCENE = preload("res://scenes/tile.tscn")  # Your Tile scene
const L0_BATTLE_DATA_POOL = [
	preload("res://events/battleGeneral/battleType/wolf_encounter.tres"),
	#preload("res://Events/battle_2.tscn"),
	#preload("res://Events/battle_3.tscn")
]

const BOARD_SIZE = 5
var grid = []  # 2D array to hold tiles
var current_tile

func _ready():
	print("game starting")
	generate_board()

func generate_board():
	print("generating board")
	for y in range(BOARD_SIZE):
		grid.append([])
		for x in range(BOARD_SIZE):
			var tile = TILE_SCENE.instantiate()
			tile.position = Vector2(x * 78, y * 78)  # spacing prev 64
			add_child(tile)

			# Assign start and boss
			if x == 0 and y == 0:
				tile.text = "Start"
				#tile.battle_data = preload("res://events/battleGeneral/battleType/...")
			elif x == BOARD_SIZE - 1 and y == BOARD_SIZE - 1:
				tile.text = "Boss"
				#tile.battle_data = preload("res://events/battleGeneral/battleType/...")#somehow make a pool of bosses?
			else:
				tile.battle_data = L0_BATTLE_DATA_POOL[randi() % L0_BATTLE_DATA_POOL.size()]
			
			grid[y].append(tile)
	current_tile = grid[0][0]
	current_tile.disabled = false
	update_tile_states()
	print("tile states set")
		
func set_current_tile(tile):
	current_tile = tile
	update_tile_states()
	
	
func update_tile_states():
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			grid[y][x].disabled = true
			#var tile = grid[y][x]
			#tile.disabled = true  #make all disabled at start
			
	var pos = get_tiles_coords(current_tile)
	var x = int(pos.x)
	var y = int(pos.y)
	
	#grid[y][x].disabled = false //makes start clickable
	
	var directions = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]#right, left, down, up
	
	for direction in directions:
		var nx = x + int(direction.x)
		var ny = y + int(direction.y)
		if nx >= 0 and nx < BOARD_SIZE and ny >= 0 and ny < BOARD_SIZE:
			grid[ny][nx].disabled = false
			
func get_tiles_coords(tile):
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			if grid[y][x] == tile:
				return Vector2(x,y)
	return Vector2(-1,-1)
