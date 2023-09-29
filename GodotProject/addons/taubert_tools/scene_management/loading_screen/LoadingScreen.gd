extends CanvasLayer
class_name LoadingScreen

func _ready() -> void:
	# Get per frame update on progress from SceneLoader
	SceneLoader.loading_progressed.connect(update_loading_percentage)

# Do all loading update logic from here
func update_loading_percentage(scene:String, percentage: float) -> void:
	pass

# Do all cleanup and reseting here
func _exit_tree() -> void:
	pass
