extends Node2D

class_name Player;

@export var max_health: int = 100;
var current_health: int = 100;
@export var sprite_texture: Texture;

@onready var health_bar = $Player/ProgressBar

func _ready():
	update_health_bar()
	
func take_damage(amount: int):
	current_health = max(current_health - amount, 0)
	update_health_bar()
	print("My hp is ", current_health)
	if current_health <= 0:
		check_death() #check for revives/prevention of death/or death
		
func update_health_bar():
	if health_bar:
		health_bar.value = current_health
		
func check_death():
	queue_free()
