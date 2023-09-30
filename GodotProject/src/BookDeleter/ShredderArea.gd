extends Area3D
class_name BookShredderArea

signal shredding()

@onready var highlight: MeshInstance3D = $"../CSGBox3D/Highlight"
@onready var animation_player: AnimationPlayer = $"../CSGBox3D/AnimationPlayer"


func _ready() -> void:
	highlight.transparency = 1.0


func toggle_highlight() -> void:
	animation_player.stop()
	animation_player.play("fade_out")


func use(book: Book) -> void:
	if book:
		book.destroy()
		shredding.emit()


func _on_body_entered(body: Node3D) -> void:
	if body is Book:
		use(body)
