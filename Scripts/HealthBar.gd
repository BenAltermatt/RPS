extends Control

var Heart = load("res://Scenes/Heart.tscn")

const TOTAL_TIME = 1.0
const INCS = 100.0

export (Texture) var full
export (Texture) var empty
var max_health = -1
var gc
var on_screen


func _ready():
	gc = get_node("GridContainer")
	on_screen = true

	
func update_health(max_hp, cur_hp):
	if max_health != max_hp:
		max_health = max_hp
		clear_grid()
		for i in range(max_health):
			gc.add_child(Heart.instance())
	
	var h_ind = 0
	for heart in gc.get_children():
		var lost = max_health - cur_hp
		if h_ind < lost:
			heart.texture = empty
		else:
			heart.texture = full
		h_ind += 1
	
	
func clear_grid():
	var gc = get_node("GridContainer")
	for child in gc.get_children():
		gc.remove_child(child)
		child.queue_free()
		

func toggle_on_screen():
	var goal = OS.window_size.y 
	
	for i in range(INCS):
		if on_screen:
			self.set_position(self.get_position() + Vector2(0, goal / INCS))
			yield(get_tree().create_timer(TOTAL_TIME / INCS), "timeout")
		else:
			self.set_position(self.get_position() - Vector2(0, goal / INCS))
			yield(get_tree().create_timer(TOTAL_TIME / INCS), "timeout")
	
	on_screen = not on_screen
