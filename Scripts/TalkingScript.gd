extends Control

signal completed_typing
signal flipped

export(float) var sec_thresh =.0018 * 5
var messages = []
const header = "[b][color=black]"
const tail = "[/b][/color]"
var typing = false
var message_ind = 0
var char_ind = 0
var since_last = 0
var complete

var flipping


const TOTAL_TIME = 1.0
const INCS = 100.0

var on_screen

var Text

# Called when the node enters the scene tree for the first time.
func _ready():
	Text = $RichTextLabel
	on_screen = false
	flipping = false

func speak(msgs):
	complete = false
	typing = true
	messages = msgs
	message_ind = 0
	char_ind = 0
	Text.text = ""

	
func _input(event):
	if (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
		typing = true
		if message_ind == len(messages):
			emit_signal("completed_typing")
			complete = true
			Text.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not complete:
		if typing:
			if char_ind == len(messages[message_ind]):
				typing = false
				message_ind += 1
				char_ind = 0
			
			if since_last > sec_thresh:
				since_last = 0
				Text.text = ""
				Text.append_bbcode(header)
				Text.append_bbcode(messages[message_ind].substr(0, char_ind + 1))
				char_ind += 1
			else:
				since_last += delta


func toggle_on_screen():
	var goal = OS.window_size.y 
	
	flipping = true
	for i in range(INCS):
		if on_screen:
			self.set_position(self.get_position() + Vector2(0, goal / INCS))
			yield(get_tree().create_timer(TOTAL_TIME / INCS), "timeout")
		else:
			self.set_position(self.get_position() - Vector2(0, goal / INCS))
			yield(get_tree().create_timer(TOTAL_TIME / INCS), "timeout")
	
	on_screen = not on_screen
	
	emit_signal("flipped")
	
