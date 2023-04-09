extends Node2D

export(float) var speed_mult
export(float) var vscale
export(float) var hscale
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
	sprite.scale.x = hscale
	sprite.scale.y = vscale
	
	animator.play("Idle")
	animator.set_speed_scale(speed_mult)

func set_texture(path):
	self.visible = false
	sprite.texture = load(path)
	animator.play("Idle")
	animator.set_speed_scale(speed_mult)
	self.visible = true
