extends Node3D

var current_wave := 0
var book = preload("res://src/book/Book.tscn")
var trash = [
	preload("res://src/BookSpawner/Trash/Trash_1.tscn"),
	preload("res://src/BookSpawner/Trash/Trash_2.tscn"),
	preload("res://src/BookSpawner/Trash/Trash_3.tscn"),
	]

var items_to_spawn := []

@onready var spawn_point := $Tube/BookSpawnPoint

func _ready() -> void:
	RoundManager.round_started.connect(round_started)


func _process(delta: float) -> void:
	if items_to_spawn.is_empty(): return
	var item = items_to_spawn.pop_back()
	if item is BookRes:
			spawn_book(item)
	if item is int:
		spawn_trash(item)

func round_started(round: int, items: Array) -> void:
	cull_existing_books()
	items_to_spawn.clear()
	items_to_spawn += items


func spawn_trash(amount: int) -> void:
	for i in range(amount):
		var trash_item: RigidBody3D = trash.pick_random().instantiate()
		spawn_point.add_child(trash_item)


func spawn_book(book_res: BookRes) -> void:
	var new_book: Book = book.instantiate()
	spawn_point.add_child(new_book)
	new_book.apply_torque_impulse(Vector3(randf(), randf(), randf()) * 3.0)
	new_book.setup(book_res)


func cull_existing_books() -> void:
	for book in get_tree().get_nodes_in_group("book"):
		book.destroy()
