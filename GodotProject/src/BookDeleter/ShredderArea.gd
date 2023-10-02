extends Area3D
class_name BookShredderArea

signal shredding()

@onready var highlight: MeshInstance3D = $"../CSGBox3D/Highlight"
@onready var animation_player: AnimationPlayer = $"../CSGBox3D/AnimationPlayer"

var disabled := false

func disable() -> void: disabled = true
func enable() -> void: disabled = false


func _ready() -> void:
	highlight.transparency = 1.0


func toggle_highlight() -> void:
	if disabled: return
	animation_player.stop()
	animation_player.play("fade_out")


func use(book: Book) -> void:
	if disabled: return
	if book:
		book.destroy()
		shredding.emit()


func _on_body_entered(body: Node3D) -> void:
	if body is Book:
		if not disabled: use(body)
		else: body.apply_central_impulse(Vector3.UP * 2)
