extends Node2D

func position_enemies():
	var count = get_child_count()
	var spacing = 150 #100
	var screen_size = get_viewport().get_visible_rect().size #new
	var start_x = screen_size.x - (spacing * count) - 20    #100 from right
	var y_pos = screen_size.y / 2  #used to be 200
	
	for i in range(count):
		var enemy = get_child(i)
		enemy.position = Vector2(start_x + i * spacing, y_pos) #used to end with 0
 
