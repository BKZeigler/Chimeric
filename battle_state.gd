extends Node


var is_player_turn := true
var selected_card: Card = null
var wand_queue: Array = []
#var player = Player  # You can assign this later
var player: Player = null
var max_mana := 10
var current_mana := 10
var player_scene := preload("res://scenes/player.tscn")
var battle_manager: Node = null
var current_level_scene
var current_tile_coords: Vector2 = Vector2(-1,-1)

func create_player():
	if not player:
		player = player_scene.instantiate()
	return player

func start_player_turn():
	is_player_turn = true
	selected_card = null

func end_player_turn():
	is_player_turn = false
	battle_manager.start_enemy_turn()

func get_selected_card():
	return selected_card

func on_card_used():
	selected_card = null
	#end_player_turn() THIS IS TURNED OFF FOR TeSTING ONLY
	# Optionally trigger enemy turn logic
func add_card(card):
	if card not in wand_queue:
		wand_queue.append(card)
		print("Queue: ", wand_queue)

func remove_card(card):
	wand_queue.erase(card)
	print("Queue: ", wand_queue)
	
func reset_mana():
	current_mana = max_mana
	
func spend_mana(amount: int) -> bool:
	if current_mana >= amount:
		current_mana -= amount
		return true
	return false
	
func execute_wand(target_enemy):
	for card in wand_queue:
		card.play_card_on_target(target_enemy)
	wand_queue.clear()
	print("Queue Cleared!")
	end_player_turn()
	
func go_to_event(battle_data):
	var scene = get_tree().current_scene
	current_level_scene = PackedScene.new()
	current_level_scene.pack(scene)
	print("Current level scene is ", current_level_scene)
	
func return_to_board():
	#if current_level_scene:
	print("trying to return")
	get_tree().change_scene_to_packed(current_level_scene)
