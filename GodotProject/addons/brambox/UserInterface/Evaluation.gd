extends CenterContainer

signal proceed

@onready var flavour_label: Label = $PanelContainer/VBoxContainer/FlavourLabel
@onready var score_label: Label = $PanelContainer/VBoxContainer/ScoreLabel
@onready var proceed_button: Button = $PanelContainer/VBoxContainer/ProceedButton
@onready var remnants_label: Label = $PanelContainer/VBoxContainer/RemnantsLabel
@onready var time_label: Label = $PanelContainer/VBoxContainer/TimeLabel

var time := 0.0

func _ready() -> void:
	visible = false
	RoundManager.round_started.connect(
		func(_x, _y): time = 0
		)


func evaluate() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true
	score_label.text = str(get_score())
	proceed_button.pressed.connect(return_control)
	var remaining_books := get_tree().get_nodes_in_group("book")
	if remaining_books.is_empty():
		remnants_label.label_settings.font_color = Color.WEB_GREEN
		remnants_label.text = "all books sorted."
	else:
		remnants_label.label_settings.font_color = Color.ORANGE_RED
		remnants_label.text = "%d books left out of shelves" % remaining_books.size()
	time_label.text = "Completion time: %.1f seconds" % time

func return_control() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	proceed.emit()
	visible = false
	proceed_button.pressed.disconnect(return_control)

func _process(delta: float) -> void:
	time += delta

func get_score() -> int:
	var label = get_tree().get_first_node_in_group("ScoreLabel")
	return int(label.text.trim_prefix("Score: "))
