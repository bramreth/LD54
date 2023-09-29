extends LoadingScreen

@export var label: Label

func update_loading_percentage(scene:String, percentage: float) -> void:
	label.text = "Loading " + str(percentage * 100.0) + "%"


# Do all cleanup and reseting here
func _exit_tree() -> void:
	pass
