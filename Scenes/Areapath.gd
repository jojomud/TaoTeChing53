extends Area



var t"res://Scenes/Mansion.tscn"
export var quit = true

func _ready():
	pass


func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to(target_scene)
		if quit == true:
			get_tree().quit()



