extends Node3D

var current_wave := 0
var book = preload("res://src/book/Book.tscn")
var trash = []

@onready var spawn_point := $Tube/BookSpawnPoint

func _ready() -> void:
	RoundManager.start_game()
	RoundManager.round_started.connect(round_started)


func round_started(round: int, items: Array) -> void:
	for item in items:
		await get_tree().create_timer(randf() + 0.1).timeout
		if item is BookRes:
			spawn_book(item)

	RoundManager.round_dispensed()


func spawn_book(book_res: BookRes) -> void:
	var new_book: Book = book.instantiate()
	spawn_point.add_child(new_book)
	new_book.apply_torque_impulse(Vector3(randf(), randf(), randf()) * 3.0)
	new_book.setup(book_res)
