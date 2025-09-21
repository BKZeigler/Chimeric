# attack_card.gd
extends Control
class_name Card

@export var attack: Attack
var is_selected = false
var cooldown_remaining: int = 0
var original_position: Vector2
var raised_offset := Vector2(0,-30)

@onready var sprite = $Sprite2D
@onready var name_label = $Name
@onready var damage_label = $Dmg_Cost_Recharge

func _ready():
	original_position = position
	if attack:
		sprite.texture = attack.sprite_texture
		name_label.text = attack.name
		damage_label.text = "DMG: %d / Cost: %d / Recharge: %d" % [attack.damage, attack.cost, attack.recharge]
		
func is_ready() -> bool:
	return cooldown_remaining <= 0

#func _on_click_area_input_event(viewport, event, shape_idx):
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#toggle_selection()

func toggle_selection():
	if not is_ready() && not is_selected:
		print("Card still on cooldown!")
		#return
	
	is_selected = !is_selected
	if is_selected:
		global_position += Vector2(0, -30)
		BattleState.selected_card = self
		BattleState.add_card(self)
	else:
		global_position -= Vector2(0, -30)
		if BattleState.selected_card == self:
			BattleState.remove_card(self)
			BattleState.selected_card = null

func play_card_on_target(target):
	print("Played ", attack.name, " on ", target.name)
	# Apply logic like damage:
	if is_ready():
		if BattleState.spend_mana(attack.cost):
			cooldown_remaining = attack.recharge
			if target.has_method("take_damage"):
				target.take_damage(attack.damage)
		else:
			print("Not enough mana")
	else:
		print("is still recharging for ", cooldown_remaining, " turn(s).") 
	toggle_selection()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		toggle_selection()
