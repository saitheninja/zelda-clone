extends "res://pickups/pickup.gd"

export(bool) var disappears = true

func body_entered(body):
	if body.name == "player":
		body.health += 1
		queue_free()