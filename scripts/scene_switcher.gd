extends Node

@onready var current_level = $level0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$level0.connect("level_changed", handle_level_changed)
	
func handle_level_changed(current_level_name: String):
	var next_level
	var next_level_name: String
	
	match current_level_name:
		"zero_go_one": #to 0_1
			next_level_name = "0_1"
		"zero_one":  #back to 0
			next_level_name = "0"
		_:
			return
		
	
	var temp = load("res://scenes/level" + next_level_name + ".tscn")
	next_level = temp.instantiate()
	call_deferred("add_child", next_level)
	next_level.connect("level_changed", handle_level_changed)
	current_level.queue_free()
	current_level = next_level
