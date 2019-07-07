extends StaticBody2D

onready var camera = get_node("../camera")
onready var player = get_node("../player")

func _ready():
    $anim.play("open")

func _process(delta):
    # make sure that doors are always open becuase then we won't walk up to it on the wrong side and not be able to get through
    # if you've already opened it from one side
    if camera.grid_pos == camera.get_grid_pos(global_position):
        if camera.get_enemies() == 0:
            if $anim.assigned_animation != "open":
                $anim.play("open")
        elif !$area.get_overlapping_bodies().has(player):
            if $anim.assigned_animation != "close":
                $anim.play("close")
    else:
        if $anim.assigned_animation != "open":
            $anim.play("open")