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

@export var scifi_books: Array[CompressedTexture2D] = [
	preload("res://MashaAssets/Annihilation.png"),
	preload("res://MashaAssets/Children of Time.png"),
	preload("res://MashaAssets/Dune.png"),
	preload("res://MashaAssets/Frankenstein.png"),
	preload("res://MashaAssets/Ringworld.png"),
	preload("res://MashaAssets/The Hitcher's Guide to the Galaxy.png"),
	preload("res://MashaAssets/The Martian.png"),
	preload("res://MashaAssets/The Stand.png"),
	preload("res://MashaAssets/The War of the Worlds.png")
]

@export var best_books: Array[CompressedTexture2D] = [
	preload("res://MashaAssets/Borris's Web.png"),
	preload("res://MashaAssets/Giant Women.png"),
	preload("res://MashaAssets/Greener Grass.png"),
	preload("res://MashaAssets/Lord of the Mosquitoes.png"),
	preload("res://MashaAssets/Murderous Mockingbird.png"),
	preload("res://MashaAssets/Sand Pile.png"),
	preload("res://MashaAssets/The Sunrise Library.png"),
	preload("res://MashaAssets/Windy Wendy Leaves Her Pan.png")
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
	var rand_book = [classic_books.pick_random(), scifi_books.pick_random(), best_books.pick_random()]
	book_mesh.get("surface_material_override/0").albedo_texture = rand_book.pick_random()
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
