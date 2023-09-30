extends RigidBody3D
class_name Book

@export var book_res: BookRes

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var book_mesh := $BookMesh
@onready var label_1: Label3D = $BookMesh/TempLabel
@onready var label_2: Label3D = $BookMesh/TempLabel2
@onready var highlight := $BookMesh/Highlight
@onready var animation_player: AnimationPlayer = $BookMesh/Highlight/AnimationPlayer

func _ready() -> void:
	setup()

func setup() -> void:
	book_res = BookRes.create_random()
	book_mesh.material_override.albedo_color = book_res.get_color()
	match book_res.sort:
		BookRes.SORT.TOP:
			label_1.text = "T"
			label_2.text = "T"
		BookRes.SORT.MIDDLE:
			label_1.text = "M"
			label_2.text = "M"
		BookRes.SORT.BOTTOM:
			label_1.text = "B"
			label_2.text = "B"


func toggle_highlight() -> void:
	animation_player.stop()
	animation_player.play("fade_out")


func pick_up() -> void:
	freeze = true
	collision_shape.disabled = true


func drop(impulse: Vector3 = Vector3.ZERO) -> void:
	freeze = false
	collision_shape.disabled = false
	apply_central_impulse(impulse)


func seperate_mesh() -> MeshInstance3D: 
	remove_child(book_mesh)
	return book_mesh
