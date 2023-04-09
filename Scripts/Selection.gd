extends Control

const TOTAL_TIME = 1.0
const INCS = 100.0

var on_screen

# Called when the node enters the scene tree for the first time.
func _ready():
	on_screen = true


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
