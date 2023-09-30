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
	book.call_deferred("pick_up")
	book.global_transform = books_root.global_transform
	book.rotate_y(PI/2)
	books.append(book)
	book.global_position += _calculate_book_offset()
	
	if books.size() == max_books: 
		full.emit(self, _calculate_score())
		particles.emitting = true


func _calculate_book_offset() -> Vector3:
	return books_root.global_transform.basis.x * ((book_offset / 2) + ((books.size() - 1) * book_offset))


func _calculate_score() -> int:
	var score = 0
	for book in books:
		var book_res: BookRes = book.book_res
		score += int(book_res.sort == sort)
		score += int(book_res.genre == genre)
	return score


func reset() -> void:
	for book in books: book.queue_free()
	books.clear()
