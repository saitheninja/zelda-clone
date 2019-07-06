extends Area2D

# tells camera which on truees to delete
#export(bool) var disappears = false

func _ready():
	connect("body_entered",self,"body_entered")
	connect("area_entered",self,"area_entered")

func area_entered(area):
	var area_parent = area.get_parent()
	# can also change it to be multiple items allowed to pickup things
	if area_parent.name == "sword":
		# pass player node into body_entered function
		body_entered(area_parent.get_parent())

func body_entered(body):
	pass