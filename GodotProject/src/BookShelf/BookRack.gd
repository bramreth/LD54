extends Area3D
class_name BookRack

signal full(rack: BookRack)

@export var sort: BookRes.SORT = BookRes.SORT.TOP
@export var max_books: int = 3

@onready var books_root: Node3D = $Books
@onready var book_offset: float = $CollisionShape3D.shape.size.x / max_books

var books := []


func _on_body_entered(body: Node3D) -> void:
	if body is Book:
		try_add_book(body)


func try_add_book(book: Book) -> void:
	if books.size() >= max_books: return
	if not book.book_res: return
#	if book.book_res.genre == genre and book.book_res.sort == sort:
	book.call_deferred("pick_up")
	book.global_transform = books_root.global_transform
	book.rotate_y(PI/2)
	books.append(book)
	book.position.x += (book_offset / 2) + ((books.size() - 1) * book_offset)
	
	if books.size() == max_books: full.emit(self)
