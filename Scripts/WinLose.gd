extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var image_path = "res://Assets/Sprites/"
var images = [["win-chaz.png","lose-chaz.png"],
				["win-kid.png","lose-kid.png"],
				["win-mom.png","lose-mom.png"]]


# Called when the node enters the scene tree for the first time.
func _ready():
	var opponent_num = 3
	var win = true
	var image = get_node("TextureRect")
	if (win == true ):
		var texture = load( image_path + images[opponent_num - 1][0] )
		print("player won")
		if (texture != null ):
			print("texture ok")
			image.texture = texture
		var button = get_node("Button")
		button.text = "Next Round"
	else:
		var texture = load( image_path + images[opponent_num - 1][1] )
		if (texture != null ):
			image.texture = texture
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
