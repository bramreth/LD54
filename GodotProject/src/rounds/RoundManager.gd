extends Node

signal round_started(round: int, books: Array)
signal unlock_full_hands()

@onready var timer: Timer = $Timer

var current_round: int = 0

const SCORE := "score"
const TIME := "time"
var total_score: Dictionary = {}


func start_game() -> void:
	current_round = 0
	total_score.clear()
	timer.start(1.0)


func evalutae() -> void:
	var evaluator = get_tree().get_first_node_in_group("evaluation")
	evaluator.proceed.connect(next_round)
	evaluator.evaluate()


func final_evaluation() -> void:
	var evaluator = get_tree().get_first_node_in_group("evaluation")
	evaluator.proceed.connect(next_round)
	evaluator.final_evaluation()


func update_score(score: float) -> void:
	if not total_score.keys().has(current_round): total_score[current_round] = {}
	total_score[current_round][SCORE] = score


func update_time(time: float) -> void:
	if not total_score.keys().has(current_round): total_score[current_round] = {}
	total_score[current_round][TIME] = time


func calculate_total_score() -> float:
	var rounds = total_score.keys().size()
	var total_score_value: float = 0.0
	for key in total_score.keys():
		total_score_value += total_score[key][SCORE]
	return total_score_value * 100 / rounds


func calculate_total_time() -> float:
	var total_time: float = 0.0
	for key in total_score.keys():
		total_time += total_score[key][TIME]
	return total_time


func next_round() -> void:
	round_started.emit(current_round, get_round_books())
	current_round += 1


#Zone 1/2 - 81 Books each
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
		10: return []
		_: return _generate_random_books(_get_round_size())


func _generate_single_genre(
	genre,
	amount: int,
	sort
) -> Array:
	var books := []
	for i in range(amount):
		var local_sort = sort
		var local_genre = genre
		printt(genre, sort)
		if genre == null: local_genre = BookRes.GENRE.values().pick_random()
		if sort == null: local_sort = BookRes.SORT.values().pick_random()
		print(sort)
		books.append(BookRes.create_from_genre(local_genre, local_sort))
	return books


func _generate_random_books(amount: int) -> Array:
	var books := []
	for i in range(amount):
		books.append(BookRes.create_random())
	return books


func _get_round_size() -> int: return (current_round + 1) * 2


func calculate_letter_grade(score: float) -> String:
	if score <= 0.10:
		return "F"
	elif score <= 0.20:
		return "D-"
	elif score <= 0.30:
		return "D"
	elif score <= 0.40:
		return "D+"
	elif score <= 0.50:
		return "C-"
	elif score <= 0.60:
		return "C"
	elif score <= 0.70:
		return "C+"
	elif score <= 0.80:
		return "B-"
	elif score <= 0.85:
		return "B"
	elif score <= 0.90:
		return "B+"
	elif score <= 0.94:
		return "A-"
	elif score <= 0.98:
		return "A"
	else:
		return "A+"


func _on_timer_timeout() -> void:
	next_round()

const TUTORIAL_ROUND_1 := 0
const TUTORIAL_ROUND_2 := 1
const TUTORIAL_ROUND_3 := 2
const BLOCKED_AREA_UNVEILED := 7
const FINAL_ROUND := 10

const TUTORIAL_1 := "tutorial_1"
const TUTORIAL_2 := "tutorial_2"
