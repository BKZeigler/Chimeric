extends Button

@export var battle_data: BattleData

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", Callable(self, "_on_tile_pressed")) # Replace with function body.


func _on_tile_pressed(): #when tile is pressed, if it has an assigned scene, go to it
	#if assigned_scene != null and not self.disabled:
		BattleState.go_to_event(battle_data)
		GlobalBattleState.battle_data = battle_data
		get_parent().set_current_tile(self)
		print("Trying to change scene")
		get_tree().change_scene_to_file("res://events/battleGeneral/Battle.tscn") #assigned_scene #change_scene_to_packed
