extends CenterContainer

signal proceed

@export var bg: TextureRect
@onready var flavour_label: Label = $PanelContainer/VBoxContainer/FlavourLabel
@onready var score_label: Label = $PanelContainer/VBoxContainer/ScoreLabel
@onready var proceed_button: Button = $PanelContainer/VBoxContainer/ProceedButton
@onready var remnants_label: Label = $PanelContainer/VBoxContainer/RemnantsLabel
@onready var time_label: Label = $PanelContainer/VBoxContainer/TimeLabel
@onready var sort_label: Label = $PanelContainer/VBoxContainer/SortLabel
@onready var genre_label: Label = $PanelContainer/VBoxContainer/GenreLabel
@onready var mistakes_label: Label = $PanelContainer/VBoxContainer/MistakesLabel

var time := 0.0
var max_mistakes = 0
var correct_sort := 0
var incorrect_sort := 0
var correct_genre := 0
var incorrect_genre := 0
var well_done: bool = false

func _ready() -> void:
	set_visiblity(false)
	genre_label.visible = false
	sort_label.visible = false
	RoundManager.round_started.connect(
		func(_x, books):
			time = 0
			max_mistakes = books.size()
	)
	UiEventBus.correct_genre.connect(
		func(is_correct):
			if is_correct:
				correct_genre += 1
			else:
				incorrect_genre += 1
				genre_label.visible = true
			genre_label.text = "%d book incorrect color" % incorrect_genre
			)
	UiEventBus.correct_sort.connect(
		func(is_correct):
			if is_correct:
				correct_sort += 1
			else:
				incorrect_sort += 1
				sort_label.visible = true
			sort_label.text = "%d book incorrect row" % incorrect_sort
	)


func evaluate() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_visiblity(true)
	score_label.text = str(get_score())
	proceed_button.pressed.connect(return_control)
	var remaining_books := get_tree().get_nodes_in_group("book")
	printt(remaining_books.size() + incorrect_genre + incorrect_sort, correct_genre, incorrect_genre, correct_sort, incorrect_sort)
	var mistakes = (remaining_books.size() + incorrect_genre + incorrect_sort)
	mistakes_label.visible = mistakes > 0
	mistakes_label.text = "%d mistakes" % mistakes
	if remaining_books.is_empty():
		remnants_label.label_settings.font_color = Color.WEB_GREEN
		remnants_label.text = "all books sorted"
	else:
		remnants_label.label_settings.font_color = Color.ORANGE_RED
		remnants_label.text = "%d books left out of shelves" % remaining_books.size()
	time_label.text = "Completion time: %.1f seconds" % time
	handle_mistakes(mistakes)
	correct_sort = 0
	incorrect_sort = 0
	correct_genre = 0
	incorrect_genre = 0

func handle_mistakes(mistakes_in: int) -> void:
	well_done = false
	var score = inverse_lerp(max_mistakes, 0, mistakes_in)
	flavour_label.text = RoundManager.calculate_letter_grade(score)
	if score >= 0.92: well_done = true
	flavour_label.label_settings.font_color = Color.ORANGE_RED.lerp(Color.GREEN, inverse_lerp(0.59, 1.0, score))
	if well_done: Announcer.queue([DialogPacketDb.quips.good_job.pick_random()])
	RoundManager.update_score(score)


func return_control() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	proceed.emit()
	set_visiblity(false)
	proceed_button.pressed.disconnect(return_control)
	genre_label.visible = false
	sort_label.visible = false

func _process(delta: float) -> void:
	time += delta

func get_score() -> int:
	var label = get_tree().get_first_node_in_group("ScoreLabel")
	return int(label.text.trim_prefix("Score: "))

func set_visiblity(is_visible: bool) -> void:
	visible = is_visible
	bg.visible = is_visible
