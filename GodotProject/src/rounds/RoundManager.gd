extends Node

signal round_started(round: int, books: Array)
signal unlock_full_hands()

@onready var timer: Timer = $Timer

var current_round: int = 0

var total_score := {}


func start_game() -> void:
	current_round = 0
	total_score.clear()
	timer.start(1.0)


func evalutae() -> void:
	var evaluator = get_tree().get_first_node_in_group("evaluation")
	evaluator.proceed.connect(next_round)
	evaluator.evaluate()


func update_score(score: float) -> void:
	total_score[current_round] = score
	print(total_score)


func next_round() -> void:
	round_started.emit(current_round, get_round_books())
	current_round += 1


#Zone 1/2 - 81 Books each
#Zone 3 - 108 Books
func get_round_books() -> Array:
	match(current_round):
		0: return _generate_single_genre(BookRes.GENRE.CLASSICS, 3, BookRes.SORT.TOP)
		1: return _generate_single_genre(BookRes.GENRE.CLASSICS, 3, BookRes.SORT.MIDDLE) + _generate_single_genre(BookRes.GENRE.CLASSICS, 3, BookRes.SORT.BOTTOM)
		2: return [7] + _generate_single_genre(BookRes.GENRE.BESTSELLERS, 1, null)
		3: return _generate_single_genre(BookRes.GENRE.CLASSICS, 7, null) + _generate_single_genre(BookRes.GENRE.BESTSELLERS, 4, null)
		4: return _generate_single_genre(BookRes.GENRE.SCIFI, 15, null)
		5: return _generate_random_books(20)
		6: return _generate_random_books(27) + [5]  #Zone 1 is fillable
		7: return _generate_random_books(30) + [30]
		8: return _generate_single_genre(null, 30, null) + [5]
		9: return _generate_random_books(30) + [8]
		_: return _generate_random_books(_get_round_size())


func _generate_single_genre(
	genre,
	amount: int,
	sort
) -> Array:
	var books := []
	for i in range(amount):
		if genre == null: BookRes.GENRE.values().pick_random()
		if sort == null: BookRes.SORT.values().pick_random()
		books.append(BookRes.create_from_genre(genre, sort))
	return books


func _generate_random_books(amount: int) -> Array:
	var books := []
	for i in range(amount):
		books.append(BookRes.create_random())
	return books


func _get_round_size() -> int: return (current_round + 1) * 2


func calculate_letter_grade(score: float) -> String:
	if score <= 0.59:
		return "F"
	elif score <= 0.62:
		return "D-"
	elif score <= 0.66:
		return "D"
	elif score <= 0.69:
		return "D+"
	elif score <= 0.72:
		return "C-"
	elif score <= 0.76:
		return "C"
	elif score <= 0.79:
		return "C+"
	elif score <= 0.82:
		return "B-"
	elif score <= 0.86:
		return "B"
	elif score <= 0.89:
		return "B+"
	elif score <= 0.92:
		return "A-"
	elif score <= 0.96:
		return "A"
	else:
		return "A+"


func _on_timer_timeout() -> void:
	next_round()

const TUTORIAL_ROUND_1 := 0
const TUTORIAL_ROUND_2 := 1
const TUTORIAL_ROUND_3 := 2
const FIRST_ALL_ONE_GENRE_ROUND := 4
const BLOCKED_AREA_UNVEILED := 7

const TUTORIAL_1 := "tutorial_1"
const TUTORIAL_2 := "tutorial_2"
