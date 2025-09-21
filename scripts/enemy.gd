#CODE SHOULD BE USED A BASE FOR GENERAL/COMMON ENEMIES
#SPECIAL ENEMIES SHOULD OVERRIDE THIS CODE WITH SPECIAL BEHAVIOR

extends Node2D

signal defeated

@export var max_health := 10
@export var sprite_texture: Texture    #Texture
@export var enemy_name := "Enemy"

var current_health := 0

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
		print("Super enemy blast attack!")
			
			
		#var selected_card = BattleState.get_selected_card()
		#if selected_card:
			#selected_card.execute(Player, self)  # self is the Enemy
			#BattleState.on_card_used()
