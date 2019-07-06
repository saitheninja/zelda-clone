extends CanvasLayer

func _process(delta):
	# get the keys variable from the player node
	$keys.frame = get_node("../player").keys