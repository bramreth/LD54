extends Node3D

@export var grip_strength := 10.0

@onready var raycast: RayCast3D = $RayCast3D
@onready var hand_target: Node3D = $HandTarget

var current_book: Book = null

func _process(delta: float) -> void:
	if current_book:
		current_book.global_transform = current_book.global_transform.interpolate_with(hand_target.global_transform, delta * grip_strength)
		current_book.look_at(self.global_position)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var collider: Object = raycast.get_collider()
		if collider and collider is Book: _pickup_book(collider)
	if event.is_action_pressed("throw"):
		if current_book: _drop_book(current_book)


func _pickup_book(book: Book) -> void:
	book.pick_up()
	current_book = book


func _drop_book(book: Book) -> void:
	book.drop(global_position.direction_to(book.global_position).normalized())
	current_book = null
