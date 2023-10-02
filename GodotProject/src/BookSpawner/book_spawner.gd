extends Node3D

signal clear_books()

var current_wave := 0
var book = preload("res://src/book/Book.tscn")
var idiot_book = preload("res://src/book/IdiotBook.tscn")
var trash = [
	preload("res://src/BookSpawner/Trash/Trash_1.tscn"),
	preload("res://src/BookSpawner/Trash/Trash_2.tscn"),
	preload("res://src/BookSpawner/Trash/Trash_3.tscn"),
	]

var items_to_spawn := []
var trash_to_spawn: int = 0

@onready var spawn_point := $Tube/BookSpawnPoint

func _ready() -> void:
	RoundManager.round_started.connect(round_started)


func _process(delta: float) -> void:
	if trash_to_spawn > 0:
		spawn_trash()
		return
	if items_to_spawn.is_empty(): return
	var item = items_to_spawn.pop_back()
	if item is BookRes:
			spawn_book(item)
	if item is int:
		trash_to_spawn = item
		spawn_trash()

func round_started(round: int, items: Array) -> void:
	cull_existing_books()
	if get_tree().get_nodes_in_group("IdiotBook").size() < 1: spawn_idiot_book()
	if randi_range(0, 2) < 1: spawn_idiot_book()
	items_to_spawn.clear()
	items_to_spawn += items


func spawn_trash() -> void:
	trash_to_spawn -= 1
	var trash_item: RigidBody3D = trash.pick_random().instantiate()
	spawn_point.add_child(trash_item)


func spawn_book(book_res: BookRes) -> void:
	var new_book: Book = book.instantiate()
	spawn_point.add_child(new_book)
	new_book.apply_torque_impulse(Vector3(randf(), randf(), randf()) * 3.0)
	new_book.setup(book_res)


func spawn_idiot_book() -> void:
	var new_book: Book = idiot_book.instantiate()
	spawn_point.add_child(new_book)


func cull_existing_books() -> void:
	clear_books.emit()
	for book in get_tree().get_nodes_in_group("book"):
		book.destroy()
