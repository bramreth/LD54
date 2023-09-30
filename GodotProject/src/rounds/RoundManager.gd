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
		if randi_range(1, 30) <= one_color_chance: books = _generate_single_genre()
		else: books = _generate_random_books()

	return books


func evalutae() -> void:
	next_round()

func next_round() -> void:
	round_started.emit(current_round, get_round_books())
	current_round += 1
	one_color_chance = clamp(one_color_chance + 1, 0, 10)


func _get_special_round() -> Array:
	if current_round == TUTORIAL_ROUND_1:
		return scripted_rounds[TUTORIAL_1].map(map_scripted_book)
	elif current_round == TUTORIAL_ROUND_2:
		return scripted_rounds[TUTORIAL_2].map(map_scripted_book)
	elif current_round == FIRST_ALL_ONE_GENRE_ROUND:
		return _generate_single_genre(BookRes.GENRE.BESTSELLERS)
	return []


func map_scripted_book(book_info: Dictionary) -> BookRes:
	return BookRes.create_from(book_info[BOOK_NAME], book_info[BOOK_GENRE], book_info[BOOK_SORT])


func _generate_single_genre(genre: BookRes.GENRE = BookRes.GENRE.values().pick_random()) -> Array:
	var books := []
	for i in range(_get_round_size()):
		books.append(BookRes.create_from_genre(genre))
	return books


func _generate_random_books() -> Array:
	var books := []
	for i in range(_get_round_size()):
		books.append(BookRes.create_random())
	return books


func _get_round_size() -> int: return (current_round + 1) * 2


func _on_timer_timeout() -> void:
	next_round()

const TUTORIAL_ROUND_1 := 0
const TUTORIAL_ROUND_2 := 1
const FIRST_ALL_ONE_GENRE_ROUND := 4

const TUTORIAL_1 := "tutorial_1"
const TUTORIAL_2 := "tutorial_2"
const BOOK_NAME := "name"
const BOOK_GENRE := "genre"
const BOOK_SORT := "sort"

const scripted_rounds: Dictionary = {
	TUTORIAL_1: [
		{BOOK_NAME: "Tutorial Book 1", BOOK_GENRE: BookRes.GENRE.CLASSICS, BOOK_SORT: BookRes.SORT.TOP},
		{BOOK_NAME: "Tutorial Book 2", BOOK_GENRE: BookRes.GENRE.CLASSICS, BOOK_SORT: BookRes.SORT.TOP},
		{BOOK_NAME: "Tutorial Book 3", BOOK_GENRE: BookRes.GENRE.CLASSICS, BOOK_SORT: BookRes.SORT.TOP}
	],
	TUTORIAL_2: [
		{BOOK_NAME: "Tutorial Book 4", BOOK_GENRE: BookRes.GENRE.CLASSICS, BOOK_SORT: BookRes.SORT.MIDDLE},
		{BOOK_NAME: "Tutorial Book 5", BOOK_GENRE: BookRes.GENRE.CLASSICS, BOOK_SORT: BookRes.SORT.MIDDLE},
		{BOOK_NAME: "Tutorial Book 6", BOOK_GENRE: BookRes.GENRE.CLASSICS, BOOK_SORT: BookRes.SORT.MIDDLE},
		{BOOK_NAME: "Tutorial Book 7", BOOK_GENRE: BookRes.GENRE.CLASSICS, BOOK_SORT: BookRes.SORT.BOTTOM},
		{BOOK_NAME: "Tutorial Book 8", BOOK_GENRE: BookRes.GENRE.CLASSICS, BOOK_SORT: BookRes.SORT.BOTTOM},
		{BOOK_NAME: "Tutorial Book 9", BOOK_GENRE: BookRes.GENRE.CLASSICS, BOOK_SORT: BookRes.SORT.BOTTOM}
	]
}
