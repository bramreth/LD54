extends RigidBody3D
class_name Book

@export var book_res: BookRes

@export var classic_books: Array[CompressedTexture2D] = [
	preload("res://MashaAssets/Dracula.png"),
	preload("res://MashaAssets/Great Expectations.png"),
	preload("res://MashaAssets/Jane Eyre.png"),
	preload("res://MashaAssets/North and South.png"),
	preload("res://MashaAssets/Tess of d'Urbervilles.png"),
	preload("res://MashaAssets/The Adventures of Sherlock Holmes.png"),
	preload("res://MashaAssets/The Picture of Dorian Gray.png"),
	preload("res://MashaAssets/Wide Sargasso Sea.png"),
	preload("res://MashaAssets/Wuthering Heights.png")
]

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var book_mesh := $BookMesh
@onready var label_1: Label3D = $BookMesh/TempLabel
@onready var label_2: Label3D = $BookMesh/TempLabel2
@onready var highlight := $BookMesh/Highlight
@onready var animation_player: AnimationPlayer = $BookMesh/Highlight/AnimationPlayer

var in_rack: bool = false

func setup(book_res_in: BookRes) -> void:
	book_res = book_res_in
	book_mesh.get("surface_material_override/0").albedo_texture = classic_books.pick_random()
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
