extends CenterContainer

signal proceed

@onready var flavour_label: Label = $PanelContainer/VBoxContainer/FlavourLabel
@onready var score_label: Label = $PanelContainer/VBoxContainer/ScoreLabel
@onready var proceed_button: Button = $PanelContainer/VBoxContainer/ProceedButton

func _ready() -> void:
	visible = false

func evaluate() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true
	score_label.text = str(get_score())
	proceed_button.pressed.connect(return_control)

func return_control() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	proceed.emit()
	visible = false
	proceed_button.pressed.disconnect(return_control)

func get_score() -> int:
	var label = get_tree().get_first_node_in_group("ScoreLabel")
	return int(label.text.trim_prefix("Score: "))
