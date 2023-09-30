extends Node3D

@onready var starting_area_shelves = [
	$BookRow,
	$BookRow3,
	$BookRow8
]

func _ready() -> void:
	RoundManager.round_started.connect(round_started)


func round_started(round: int, _books: Array) -> void:
	match(round):
		RoundManager.TUTORIAL_ROUND_1: show_tutorial_shelf()
		RoundManager.TUTORIAL_ROUND_2: show_first_area()
		_: pass


func show_tutorial_shelf() -> void:
	var shelf_row: BookShelfRow = starting_area_shelves.front()
	shelf_row.get_shelf_for_genre(BookRes.GENRE.CLASSICS).reset()


func show_first_area() -> void:
	for row in starting_area_shelves:
		if starting_area_shelves.front() == row:
			row.get_shelf_for_genre(BookRes.GENRE.SCIFI).reset()
			row.get_shelf_for_genre(BookRes.GENRE.BESTSELLERS).reset()
		else:
			row.reset_all()
