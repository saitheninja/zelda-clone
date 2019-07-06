extends KinematicBody2D

var TYPE  = "ENEMY"
export(int) var SPEED

var movedir = Vector2(0,0)
var knockdir = Vector2(0,0)
var spritedir = "down"

export(int) var MAXHEALTH
onready var health = MAXHEALTH
# any time hitstun is ticking down, the thing is in hitstun - immune to damage
var hitstun = 0
var texture_default = null
var texture_hurt = null

func _ready():
	if TYPE == "ENEMY":
		set_collision_mask_bit(1,1)
		set_physics_process(false)
	texture_default = $Sprite.texture
	texture_hurt = load($Sprite.texture.get_path().replace(".png","_hurt.png"))

func movement_loop():
	var motion 
	if hitstun == 0:
		motion = movedir.normalized() * SPEED
	else:
		motion = knockdir.normalized() * 125 
	
	move_and_slide(motion, Vector2(0,0))

func spritedir_loop():
	match movedir:
		Vector2(-1, 0):
			spritedir = "left"
		Vector2(1, 0):
			spritedir = "right"
		Vector2(0, -1):
			spritedir = "up"
		Vector2(0, 1):
			spritedir = "down"

func anim_switch(animation):
	var newanim = str(animation, spritedir)
	# dollar sign gets node, therefore we got anim node
	if $anim.current_animation != newanim:
		$anim.play(newanim)

func damage_loop():
	if hitstun > 0:
		hitstun -= 1
		$Sprite.texture = texture_hurt
	else:
		$Sprite.texture = texture_default
		if TYPE == "ENEMY" && health <= 0:
			var death_animation = preload("res://enemies/enemy_death.tscn").instance()
			get_parent().add_child(death_animation)
			death_animation.global_transform = global_transform
			queue_free()
	# returns a list of every kinematic or static body that the hitbox is colliding with
	# for every body in that list
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		# histun not happening, the thing can do damage, and not the same type (enemy or player)
		if hitstun == 0 and body.get("DAMAGE") != null and body.get("TYPE") != TYPE:
			health -= body.get("DAMAGE")
			hitstun = 10
			# transform.origin is the x and y
			knockdir = global_transform.origin - body.global_transform.origin

# item variable that we're passing in will just be a direct path to the sword scene
func use_item(item):
	var newitem = item.instance()
	# make a list of all the instances we have of an item
	newitem.add_to_group(str(newitem.get_name(), self))
	add_child(newitem)
	# check how many of that item exists, delete it if it's higher than maxamount
	if get_tree().get_nodes_in_group(str(newitem.get_name(), self)).size() > newitem.maxamount:
		newitem.queue_free()
