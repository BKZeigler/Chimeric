extends Resource
class_name Attack

@export var name: String = "Unnamed Attack"
@export var damage: int = 0
@export var cost: int = 1
@export var recharge: int = 1
@export var sprite_texture: Texture

func execute(user, target):
	target.take_damage(damage)
