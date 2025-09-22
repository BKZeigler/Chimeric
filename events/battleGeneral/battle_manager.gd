extends Node

#@export var battle_data: BattleData
var battle_data = GlobalBattleState.battle_data
@onready var enemy_container = $"../EnemyContainer" #might not need? just use battle data

var enemy_scene_paths: Array[String] = []
var alive_enemies: Array[Node] = []
var strike = preload("res://cards/Strike/Strike.tres")
var special_strike = preload("res://cards/SpecialStrike/special_strike.tres")
var current_enemy_index = 0
var player_hand: Array = []

#func _ready():
#	spawn_enemies()
	
func _ready():
	$EnemyTurnTimer.connect("timeout", Callable(self, "_on_enemy_turn_timeout"))
	BattleState.battle_manager = self
	if battle_data:
		print("battle data found")
		spawn_enemies_from_data()
		
		var player_instance = BattleState.create_player()
		add_child(player_instance)
		position_player(player_instance)
		
		spawn_card(strike)
		spawn_card(strike)
		spawn_card(special_strike)

func spawn_enemies_from_data():
	enemy_container.get_children().map(func(child): child.queue_free()) #remove any enemies in seen before fight
	alive_enemies.clear()
	
	if GlobalBattleState.battle_data != null:
		battle_data = GlobalBattleState.battle_data
		GlobalBattleState.battle_data = null
	else:
		push_error("BattleManager: battle_data not set!")
		return
	
	for scene in battle_data.enemy_scenes: #load each enemy scene in the battle data package
		var enemy = scene.instantiate()
		enemy_container.add_child(enemy)
		alive_enemies.append(enemy)

		#need to make a connect to a 'defeated' signal when enemies emit one
		if enemy.has_signal("defeated"):
			enemy.connect("defeated", Callable(self, "_on_enemy_defeated"))
	
	enemy_container.position_enemies()
	
func _on_enemy_defeated(enemy):
	alive_enemies.erase(enemy)

	if alive_enemies.is_empty():
		print("Victory!")#end battle, show loot, etc.	
		
func position_player(player_node: Player):
	var screen_size = get_viewport().get_visible_rect().size
	var x = 150
	var y = screen_size.y / 2
	
	player_node.position = Vector2(x,y)
	
func spawn_card(attack_resource: Attack):
	var card_scene = preload("res://scenes/Card.tscn")
	var card_instance = card_scene.instantiate()

	# Assign the attack resource to the card instance
	card_instance.attack = attack_resource
	add_child(card_instance)
	player_hand.append(card_instance)

	# Position the card at the bottom center of the screen
	var screen_size = get_viewport().get_visible_rect().size
	var index = get_child_count() - 1
	var card_width = 250
	var start_x = screen_size.x / 2 - ((card_width * (index + 1)) / 2)
	var pos_x = start_x + index * card_width
	card_instance.position = Vector2(pos_x, screen_size.y - 100)
	
func start_enemy_turn():
		$EnemyTurnTimer.start(1.0)
	
func _attack_next_enemy():
	for enemy in alive_enemies:
		enemy.enemy_fight_pattern()
		
	end_enemy_turn()
		
func _on_enemy_turn_timer_timeout() -> void:
	_attack_next_enemy()
	
func end_enemy_turn():
	for card in player_hand:
		if card.cooldown_remaining > 0:
			card.cooldown_remaining -= 1
	BattleState.start_player_turn()
	

#func end_battle():    #example of end battle
	#print("Battle finished!")
	#show_loot_screen()
	#await get_tree().create_timer(2.0).timeout
	#return_to_map()	
	
#signal defeated    #example of damage/death function located in enemy code
			#
#func take_damage(amount):
	#health -= amount
	#if health <= 0:
		#emit_signal("defeated")
		

#func spawn_enemies():
	#for path in enemy_scene_paths:
		#var enemy_scene = load(path)
		#var enemy_instance = enemy_scene.instantiate()
		#enemy_container.add_child(enemy_instance)
		#can set positions, and difficulty here.
