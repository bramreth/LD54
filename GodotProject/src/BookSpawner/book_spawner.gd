extends Node3D

var book = preload("res://src/book/Book.tscn")
@onready var spawn_point := $Tube/BookSpawnPoint

func _on_timer_timeout():
	var new_book = book.instantiate()
	spawn_point.add_child(new_book)
