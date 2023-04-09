extends Node2D

export(float) var speed_mult
export(Texture) var anim_frames
export(int) var hframes = 3

var animator
var sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	animator = $AnimationPlayer
	sprite = $Sprite
	
	sprite.hframes = hframes
	
	sprite.texture = anim_frames
	
	animator.play("Idle")
	animator.set_speed_scale(speed_mult)

func set_texture(path):
	self.visible = false
	sprite.texture = load(path)
	animator.play("Idle")
	animator.set_speed_scale(speed_mult)
	self.visible = true
