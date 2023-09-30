extends Node3D

var current_wave := 0
var book = preload("res://src/book/Book.tscn")

@onready var spawn_point := $Tube/BookSpawnPoint

func _ready() -> void:
	wave(8)

func _on_timer_timeout():
	if current_wave > 0:
		current_wave -= 1
		var new_book = book.instantiate()
		spawn_point.add_child(new_book)

func wave(new_books: int) -> void:
	current_wave += new_books
