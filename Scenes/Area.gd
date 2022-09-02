extends Area



export(PackedScene) var target_scene
export var quit = true

func _ready():
	pass


func _on_Area_body_entered(body):
	get_tree().change_scene_to(target_scene)
