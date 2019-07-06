extends CanvasLayer

onready var player = get_node("../player")

const HEART_ROW_SIZE = 8
const HEART_OFFSET = 8

func _ready():
	# draw the correct no. of hearts for max
	for i in player.MAXHEALTH:
		var new_heart = Sprite.new()
		new_heart.texture = $hearts.texture
		new_heart.hframes = $hearts.hframes
		$hearts.add_child(new_heart)

func _process(delta):
	for heart in $hearts.get_children():
		var index = heart.get_index()

		# chooses the correct x, y position to place the heart
		var x = (index % HEART_ROW_SIZE) * HEART_OFFSET
		var y = (index / HEART_ROW_SIZE) * HEART_OFFSET
		heart.position = Vector2(x,y)

		# draw the correct frames
		var last_heart = floor(player.health)
		if index > last_heart:
			heart.frame = 0
		if index == last_heart:
			heart.frame = (player.health - last_heart) * 4
		if index < last_heart:
			heart.frame = 4



	# get the keys variable from the player node
	$keys.frame = player.keys