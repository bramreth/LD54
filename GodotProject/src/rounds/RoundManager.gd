extends Node

signal round_started(round: int, books: Array)

@onready var timer: Timer = $Timer

var current_round: int = 0
var one_color_chance: int = 0


func start_game() -> void:
	current_round = 0
	one_color_chance = 0
	timer.start(1.0)


func get_round_books() -> Array:
	var books := _get_special_round()
	if books.is_empty():
		if randi_range(1, 30) <= one_color_chance: books = _generate_single_genre(null, _get_round_size(), null)
		else: books = _generate_random_books(_get_round_size())

	return books


func evalutae() -> void:
	var evaluator = get_tree().get_first_node_in_group("evaluation")
	evaluator.proceed.connect(next_round)
	evaluator.evaluate()

func next_round() -> void:
	round_started.emit(current_round, get_round_books())
	current_round += 1
	one_color_chance = clamp(one_color_chance + 1, 0, 10)


#Zone 1 - 81 Books
#Zone 2/3 - 108 Books each
func _get_special_round() -> Array:
	match(current_round):
		0: return _generate_single_genre(BookRes.GENRE.CLASSICS, 3, BookRes.SORT.TOP)
		1: return _generate_single_genre(BookRes.GENRE.CLASSICS, 3, BookRes.SORT.MIDDLE) + _generate_single_genre(BookRes.GENRE.CLASSICS, 3, BookRes.SORT.BOTTOM)
		2: return [7] + _generate_single_genre(BookRes.GENRE.BESTSELLERS, 1, null)
		3: return _generate_single_genre(BookRes.GENRE.CLASSICS, 7, null) + _generate_single_genre(BookRes.GENRE.BESTSELLERS, 4, null)
		4: return _generate_single_genre(BookRes.GENRE.SCIFI, 15, null)
		5: return _generate_random_books(20)
		6: return _generate_random_books(27)  #Zone 1 is fillable
		_: return _generate_random_books(_get_round_size())


func _generate_single_genre(
	genre, 
	amount: int,
	sort
) -> Array:
	var books := []
	for i in range(amount):
		if not genre: BookRes.GENRE.values().pick_random()
		if not sort: BookRes.SORT.values().pick_random()
		books.append(BookRes.create_from_genre(genre, sort))
	return books


func _generate_random_books(amount: int) -> Array:
	var books := []
	for i in range(amount):
		books.append(BookRes.create_random())
	return books


func _get_round_size() -> int: return (current_round + 1) * 2


func _on_timer_timeout() -> void:
	next_round()

const TUTORIAL_ROUND_1 := 0
const TUTORIAL_ROUND_2 := 1
const TUTORIAL_ROUND_3 := 2
const FIRST_ALL_ONE_GENRE_ROUND := 4

const TUTORIAL_1 := "tutorial_1"
const TUTORIAL_2 := "tutorial_2"
