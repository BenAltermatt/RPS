extends Control

signal displayed

const SUSTAIN_RATIO = .5

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.visible = false


func count_down(time, extra):
	$Rock.visible = true
	yield(get_tree().create_timer(time * SUSTAIN_RATIO), "timeout")
	$Rock.visible = false
	yield(get_tree().create_timer(time - time * SUSTAIN_RATIO), "timeout")

	$Paper.visible = true
	yield(get_tree().create_timer(time * SUSTAIN_RATIO), "timeout")
	$Paper.visible = false
	yield(get_tree().create_timer(time - time * SUSTAIN_RATIO), "timeout")

	$Scissors.visible = true
	yield(get_tree().create_timer(time * SUSTAIN_RATIO), "timeout")
	$Scissors.visible = false
	yield(get_tree().create_timer(time - time * SUSTAIN_RATIO), "timeout")

	$Shoot.visible = true
	yield(get_tree().create_timer(extra), "timeout")

	emit_signal("displayed")


func hide_shoot():
	$Shoot.visible = false
