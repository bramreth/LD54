extends Node

signal round_started(round: int, books: Array)

@onready var timer: Timer = $Timer

var current_round: int = 0


func start_game() -> void:
	current_round = 0
	timer.start(1.0)


func get_round_books() -> Array:
	var books := _get_special_round()
	if books.is_empty():
		books = _generate_random_books()
	
	return books


func round_dispensed() -> void:
	print("timer started")
	timer.start(5.0)


func _get_special_round() -> Array:
	if current_round == 0: 
		return scripted_rounds[TUTORIAL_1].map(map_scripted_book)
	elif current_round == 1: 
		return scripted_rounds[TUTORIAL_2].map(map_scripted_book)
	return []


func map_scripted_book(book_info: Dictionary) -> BookRes:
	return BookRes.create_from(book_info[BOOK_NAME], book_info[BOOK_GENRE], book_info[BOOK_SORT])



func _generate_random_books() -> Array:
	var books := []
	for i in range((current_round + 1) * 2):
		books.append(BookRes.create_random())
	print(str(current_round) + ": " + str(books))
	return books


func _on_timer_timeout() -> void:
	round_started.emit(current_round, get_round_books())
	current_round += 1


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
