extends Node2D

# types that are the same can't hurt each other, rememeber
var TYPE = null
const DAMAGE = 0.5 

# how many of that item can exist for that entity, that can be active at once
# e.g. max 3 arrows in the air at a time
var maxamount = 1

func _ready():
	TYPE = get_parent().TYPE
	$anim.connect("animation_finished",self,"destroy")	
	$anim.play(str("swing",get_parent().spritedir))
	# check states, and change them to swinging state; makes enemies swing the sword if they can
	if get_parent().has_method("state_swing"):
		get_parent().state = "swing"

func destroy(animation):
	if get_parent().has_method("state_swing"):
		get_parent().state = "default"
	queue_free()