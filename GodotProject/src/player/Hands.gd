extends Node3D
class_name Hands

@export var grip_strength := 10.0
@export var hand_size := 1
@export var player: CharacterBody3D

@onready var camera_3d: Camera3D = $"../Camera3D"
@onready var raycast: RayCast3D = $RayCast3D
@onready var hand_target: Node3D = $HandTarget
@onready var debug_hand: MeshInstance3D = $HandTarget/DebugHand
@onready var remotes := [
	$HandTarget/FloatingRemote, $HandTarget/FloatingRemote2, $HandTarget/FloatingRemote3
]
@onready var remote_targets:= [
	$HandTarget/DebugHand, $HandTarget/DebugHand2, $HandTarget/DebugHand3
]

var current_book: Book = null
var books := []

func _ready() -> void:
	RoundManager.unlock_full_hands.connect(func(): hand_size = 3)


func clear_books() -> void:
	books.clear()


func get_top_book(pop = false) -> Book: 
	if not books.is_empty(): 
		if pop: return books.pop_front() 
		else: return books.front() 
	else: return null


func get_bottom_book(pop = false) -> Book:
	if not books.is_empty(): 
		if pop: return books.pop_back() 
		else: return books.back() 
	else: return null


func _process(_delta: float) -> void:
	var collider: Object = raycast.get_collider()
	if collider and collider.is_in_group("highlightable"):
		collider.toggle_highlight()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var collider: Object = raycast.get_collider()
		if collider is Book: _pickup_book(collider)
		elif collider is BookRack: _add_book_to_rack(collider)
		elif collider is TaskAppraisalLever: collider.pull()
		elif collider is BookShredderArea: if is_instance_valid(get_top_book()): collider.use(get_top_book(true)) #Probably needs to pop the book off the array
	if event.is_action_pressed("throw"):
		if is_instance_valid(get_top_book()): _drop_book(get_top_book(true))
	if event.is_action_pressed("inspect"):
		get_top_book().inspect()


func _add_book_to_rack(rack: BookRack) -> void:
	if rack.is_full(): return
	if books.is_empty(): return
	var book := get_top_book(true)
	_drop_book(book)
	rack.try_add_book(book)




func _pickup_book(book: Book) -> void:
	if get_bottom_book() and is_instance_valid(get_bottom_book()) and books.size() >= hand_size:
		_drop_book(get_bottom_book(true), 0.01)
	book.pick_up()
#	current_book = book
	if not books.is_empty(): get_top_book().stop_inspect()
	books.push_front(book)
	update_remotes()


func update_remotes() -> void:
	for remote in remotes: remote.remote_path = NodePath()
	for i in range(books.size()):
		var book = books[i]
		var remote = remotes[i]
		var hand_tween: Tween
	#	if is_instance_valid(hand_tween) and hand_tween.is_running():
	#		hand_tween.kill()
		hand_tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		hand_tween.tween_method(
			tween_position.bind(book.global_position, i), 0.0, 1.0, 0.5
		)
		remote.remote_path = remote.get_path_to(book)


func tween_position(weight: float, book_pos: Vector3, i: int) -> void:
	var pos = hand_target.global_position
	var direction = global_position.direction_to(hand_target.global_position)
	pos += (i * direction.normalized() * 0.2) + (i * -global_transform.basis.x * 0.2)
	remote_targets[i].global_position = lerp(book_pos, pos, weight)

func _drop_book(book: Book, force: float = 2.5) -> void:
	if not book:
		return
	books.erase(book)
	update_remotes()
	book.drop((-camera_3d.global_transform.basis.z + camera_3d.global_transform.basis.z * 0.5).normalized() * force)
