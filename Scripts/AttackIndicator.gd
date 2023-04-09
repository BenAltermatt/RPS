extends Control

var cur_disp = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.visible = false
		
	$Empty.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func toggle(val, on):
	match val:
		0: $Rock.visible = on
		1: $Paper.visible = on
		2: $Scissors.visible = on
		3: $Cheat.visible = on 
		
func disp(val):
	toggle(cur_disp, false)
	toggle(val, true)
	cur_disp = val
	
func undisp():
	toggle(cur_disp, false)
	toggle(-1, true)
	cur_disp = -1
	
