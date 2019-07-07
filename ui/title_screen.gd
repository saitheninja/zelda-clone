extends Control

var scene_path_to_load

# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu/CentreRow/Buttons/NewGameButton.grab_focus()
	for button in $Menu/CentreRow/Buttons.get_children():
		button.connect("pressed",self,"on_Button_pressed",[button.scene_to_load])

func on_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
	get_tree().change_scene_to(scene_path_to_load)
