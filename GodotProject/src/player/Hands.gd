extends Node3D

@export var grip_strength := 10.0
@export var player: CharacterBody3D

@onready var raycast: RayCast3D = $RayCast3D
@onready var hand_target: Node3D = $HandTarget
@onready var remote := $HandTarget/FloatingRemote
@onready var debug_hand: MeshInstance3D = $HandTarget/DebugHand


var current_book: Book = null


func _process(_delta: float) -> void:
	var collider: Object = raycast.get_collider()
	if collider and collider.is_in_group("highlightable"):
		collider.toggle_highlight()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var collider: Object = raycast.get_collider()
		if collider is Book: _pickup_book(collider)
		elif collider is BookRack: _add_book_to_rack(collider)
	if event.is_action_pressed("throw"):
		if current_book: _drop_book(current_book)


func _add_book_to_rack(rack: BookRack) -> void:
	if rack.is_full(): return
	if not current_book: return
	var book := current_book
	_drop_book(book)
	rack.try_add_book(book)


var hand_tween: Tween

func _pickup_book(book: Book) -> void:
	if current_book:
		_drop_book(current_book)
	book.pick_up()
	current_book = book
	if is_instance_valid(hand_tween) and hand_tween.is_running():
		hand_tween.kill()
	hand_tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	hand_tween.tween_method(
		tween_position.bind(book.global_position), 0.0, 1.0, 0.5
	)
	remote.remote_path = remote.get_path_to(book)

func tween_position(weight: float, book_pos: Vector3) -> void:
	debug_hand.global_position = lerp(book_pos, hand_target.global_position, weight)

func _drop_book(book: Book) -> void:
	if not book:
		return
	remote.remote_path = NodePath()
	book.drop(global_position.direction_to(book.global_position).normalized() + Vector3(0.0, 0.5, 0.0) * 2.5)
	current_book = null
