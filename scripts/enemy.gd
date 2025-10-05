#CODE SHOULD BE USED A BASE FOR GENERAL/COMMON ENEMIES
#SPECIAL ENEMIES SHOULD OVERRIDE THIS CODE WITH SPECIAL BEHAVIOR

extends Node2D

signal defeated

@export var max_health := 10
@export var sprite_texture: Texture    #Texture
@export var enemy_name := "Enemy"

var current_health := 0
var statuses = []

func _ready():
	current_health = max_health
	if $Sprite2D and sprite_texture:
		$Sprite2D.texture = sprite_texture

#func _process(delta):
	#if not BattleState.is_player_turn:
		#enemy_fight_pattern()
		
func take_damage(amount: int):
	print("I'm taking dmg!")
	current_health -= amount
	print("I'm at " + str(current_health)  + " health")
	if current_health <= 0:
		die()
		
func apply_status(type: String, data: Dictionary):
	#target.apply_status("bleed", {"damage": 1, "duration": 3}) Storing statuses here for right now.
	#target.apply_status("weakness2", {"level": 2, "duration": 3})
	#target.apply_status("poison",{"amount": 5, "duration": 5})
	var found = false
	print("statuses before applying:", statuses)
	for status in statuses:
		if status.has("type") and status["type"] == type:
			found = true
			if type == "poison":
				status["data"]["amount"] += data.get("amount", 0)
			status["turns_left"] += data.get("duration", 1)
			break
		
	if not found:
		statuses.append({
			"type": type,
			"data": data,
			"turns_left": data.get("duration", 1)
			})	
		print("Applied status: ", type, data)

func process_statuses():
	for status in statuses:
		match status["type"]:
			"bleed":
				take_damage(status["data"]["damage"])
			"weakness2":
				pass
			"poison":
				take_damage(status["data"]["amount"])
				status["data"]["amount"] -= 1
		status["turns_left"] -= 1
	statuses = statuses.filter(func(s): 
		return s["turns_left"] > 0 and (s["type"] != "poison" or s["data"]["amount"] > 0)
		)
	print("Current Statuses: ", statuses)
		
func die():
	print("I died!!")
	emit_signal("defeated", self)
	queue_free()

func _on_click_surface_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_enemy_clicked()
		
func _on_enemy_clicked():
	print("Ive been clicked!")
	if BattleState.is_player_turn:
		#if BattleState.selected_card:
			#BattleState.selected_card.play_card_on_target(self)
		if BattleState.wand_queue != null:
				BattleState.execute_wand(self)

func enemy_fight_pattern():
	if BattleState.is_player_turn == false:
		process_statuses()
		print("Super enemy blast attack!")
		if BattleState.player and BattleState.player.has_method("take_damage"):
			if statuses.any(func(s): return s.type == "weakness2"):
				BattleState.player.take_damage(1)
			else:
				BattleState.player.take_damage(5)
			
			
		#var selected_card = BattleState.get_selected_card()
		#if selected_card:
			#selected_card.execute(Player, self)  # self is the Enemy
			#BattleState.on_card_used()
