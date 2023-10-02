extends Area3D
class_name BookRack

signal full(rack: BookRack, score: int)

@export var sort: BookRes.SORT = BookRes.SORT.TOP
@export var max_books: int = 3

@onready var books_root: Node3D = $Books
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var book_offset: float = $CollisionShape3D.shape.size.x / max_books

@onready var animation_player: AnimationPlayer = $Highlight/AnimationPlayer

var genre: BookRes.GENRE
var books := []

func toggle_highlight() -> void:
	if books.size() < max_books:
		animation_player.stop()
		animation_player.play("fade_out")


func _on_body_entered(body: Node3D) -> void:
	if body is Book:
		try_add_book(body)


func is_full() -> bool: return books.size() >= max_books

func try_add_book(book: Book) -> void:
	if is_full(): return
	if not book.book_res: return
	if book.is_in_group("IdiotBook"): return
	if book.in_rack: return
	book.in_rack = true
	var mesh = book.seperate_mesh()
	var book_origin = book.global_transform
	books.append(book.book_res)
	books_root.add_child(mesh)

	if book.book_res.genre == genre:
		UiEventBus.correct_sort.emit(book.book_res.sort == sort)
	else:
		UiEventBus.correct_genre.emit(book.book_res.genre == genre)

	book.queue_free()

	mesh.global_transform = books_root.global_transform
	mesh.rotate_y(PI/2)
	mesh.rotate_x(-PI/2)


	mesh.global_position += _calculate_book_offset()
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(mesh, "global_transform", mesh.global_transform, 0.25).from(book_origin)


	if books.size() == max_books:
		full.emit(self, _calculate_score())
		particles.emitting = true


func _calculate_book_offset() -> Vector3:
	return books_root.global_transform.basis.x * ((book_offset / 2) + ((books.size() - 1) * book_offset))


func _calculate_score() -> int:
	var score = 0
	for book_res in books:
		score += 1
		score += int(book_res.sort == sort)
		score += int(book_res.genre == genre)
	return score


func reset() -> void:
	for mesh in books_root.get_children():
		mesh.queue_free()
	books.clear()
