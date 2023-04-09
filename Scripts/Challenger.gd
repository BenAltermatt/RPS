extends Node2D

export(float) var speed_mult
export(Texture) var anim_frames

var animator
var sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	animator = $AnimationPlayer
	sprite = $Sprite
	
	sprite.texture = anim_frames
	
	animator.play("Idle")
	animator.set_speed_scale(speed_mult)

