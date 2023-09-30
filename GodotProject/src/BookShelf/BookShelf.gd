extends Area3D
class_name BookShelf

@export var genre: BookRes.GENRE = BookRes.GENRE.BESTSELLERS
@export var sort: BookRes.SORT = BookRes.SORT.TOP
@export var book_offset: float = 0.32

@onready var books_root: Node3D = $Books

var books := []


func _on_body_entered(body: Node3D) -> void:
	if body is Book:
		try_add_book(body)


func try_add_book(book: Book) -> void:
	if not book.book_res: return
	if book.book_res.genre == genre and book.book_res.sort == sort:
		book.call_deferred("pick_up")
		book.global_transform = books_root.global_transform
		book.rotate_y(PI/2)
		books.append(book)
		book.position.x += (books.size() - 1) * book_offset
