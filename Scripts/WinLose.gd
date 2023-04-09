extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var image_path = "res://Assets/Sprites/"
var win 

# Called when the node enters the scene tree for the first time.
func _ready():
	var opponent_num = GLSingleton.cur_op_ind
	win = GLSingleton.won
	var image = get_node("TextureRect")
	var button = get_node("Button")
	
	if (win == true ):
		var texture = load( image_path + GLSingleton.ops[opponent_num].p_win_path + ".png")
		print("player won")
		if (texture != null ):
			print("texture ok")
			image.texture = texture
		button.text = "Next Round"
	else:
		var texture = load( image_path + GLSingleton.ops[opponent_num].p_lose_path + ".png")
		if (texture != null ):
			print("Texture ok")
			image.texture = texture
		button.text = "Retry"




func _on_Button_pressed():
	if win:
		GLSingleton.cur_op_ind += 1
	GLSingleton.won = false
	
	get_tree().change_scene("res://Scenes/Battle.tscn")
