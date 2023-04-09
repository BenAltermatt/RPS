extends Node

signal throw_clicked(throw)

export(Texture) var hover
export(Texture) var pressed
export(Texture) var normal
export(String) var text
export(int) var throw_val

func _ready():
	
	get_node("TextureButton").texture_normal = normal
	get_node("TextureButton").texture_pressed = pressed
	get_node("TextureButton").texture_hover = hover
	get_node("RichTextLabel").text = ""
	get_node("RichTextLabel").append_bbcode(text)


func _on_TextureButton_pressed():
	emit_signal("throw_clicked", throw_val)
	print("THrown %d" % throw_val)

