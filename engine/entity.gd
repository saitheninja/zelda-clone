extends KinematicBody2D

var TYPE  = "ENEMY"
export(int) var SPEED

var movedir = Vector2(0,0)
var knockdir = Vector2(0,0)
var spritedir = "down"

# any time hitstun is ticking down, the thing is in hitstun - immune to damage
var hitstun = 0
var health = 1

func movement_loop():
	var motion 
	if hitstun == 0:
		motion = movedir.normalized() * SPEED
	else:
		motion = knockdir.normalized() * SPEED * 1.5
	
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
	
#func use_item(item):
#    var newitem = item.instance()
#    var groupname = str(item, self)
#    newitem.add_to_group(groupname)
#    add_child(newitem)
#    if get_tree().get_nodes_in_group(groupname).size() > newitem.maxamount:
#        newitem.queue_free()
#        return
#    newitem._ready()