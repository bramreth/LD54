extends Node3D

@onready var initial_bookrow: BookShelfRow = $BookRow

func _ready() -> void:
	RoundManager.round_started.connect(round_started)


func round_started(round: int, _books: Array) -> void:
	match(round):
		RoundManager.TUTORIAL_ROUND_1: show_tutorial_shelf()
		RoundManager.TUTORIAL_ROUND_2: pass
		2: show_totorial_row()
		3: show_first_area()
		_: pass


func show_tutorial_shelf() -> void:
	initial_bookrow.get_shelf_for_genre(BookRes.GENRE.CLASSICS).front().reset()


func show_totorial_row() -> void:
	var row = get_tree().get_first_node_in_group("zone_1_tutorial_bookrow")
	row.get_shelf_for_genre(BookRes.GENRE.CLASSICS).back().reset()
	row.get_shelf_for_genre(BookRes.GENRE.BESTSELLERS).front().reset()



func show_first_area() -> void:
	for row in get_tree().get_nodes_in_group("zone_1_bookrow"):
		row.reset_all()
