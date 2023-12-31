extends RigidBody3D
class_name Book

@export var book_res: BookRes

@export var classic_books: Array[CompressedTexture2D] = [
	preload("res://MashaAssets/Dracula.png"),
	preload("res://MashaAssets/North and South.png"),
	preload("res://MashaAssets/The Picture of Dorian Gray.png")
]

@export var classic_books_top: Array[CompressedTexture2D] = [
	preload("res://MashaAssets/Great Expectations.png"),
	preload("res://MashaAssets/Tess of d'Urbervilles.png"),
	preload("res://MashaAssets/Wide Sargasso Sea.png")
]

@export var classic_books_bottom: Array[CompressedTexture2D] = [
	preload("res://MashaAssets/Jane Eyre.png"),
	preload("res://MashaAssets/The Adventures of Sherlock Holmes.png"),
	preload("res://MashaAssets/Wuthering Heights.png")
]

@export var scifi_books: Array[CompressedTexture2D] = [
	preload("res://MashaAssets/Children of Time.png"),
	preload("res://MashaAssets/The Martian.png"),
	preload("res://MashaAssets/The War of the Worlds.png"),
	preload("res://MashaAssets/Gideon the Ninth.png")
]

@export var scifi_books_top: Array[CompressedTexture2D] = [
	preload("res://MashaAssets/Annihilation.png"),
	preload("res://MashaAssets/Ringworld.png"),
	preload("res://MashaAssets/The Stand.png"),
]

@export var scifi_books_bottom: Array[CompressedTexture2D] = [
	preload("res://MashaAssets/Dune.png"),
	preload("res://MashaAssets/Frankenstein.png"),
	preload("res://MashaAssets/The Hitcher's Guide to the Galaxy.png")
]

@export var best_books: Array[CompressedTexture2D] = [
	preload("res://MashaAssets/Giant Women.png"),
	preload("res://MashaAssets/Murderous Mockingbird.png")
]

@export var best_books_top: Array[CompressedTexture2D] = [
	preload("res://MashaAssets/Borris's Web.png"),
	preload("res://MashaAssets/The Sunrise Library.png"),
	preload("res://MashaAssets/Windy Wendy Leaves Her Pan.png")
]

@export var best_books_bottom: Array[CompressedTexture2D] = [
	preload("res://MashaAssets/Greener Grass.png"),
	preload("res://MashaAssets/Lord of the Mosquitoes.png"),
	preload("res://MashaAssets/Sand Pile.png"),
]

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var book_mesh := $BookMesh
@onready var label_1: Label3D = $BookMesh/TempLabel
@onready var label_2: Label3D = $BookMesh/TempLabel2
@onready var highlight := $BookMesh/Highlight
@onready var animation_player: AnimationPlayer = $BookMesh/Highlight/AnimationPlayer
@onready var mesh_animation_player: AnimationPlayer = $BookMesh/AnimationPlayer

var in_rack: bool = false

func setup(book_res_in: BookRes) -> void:
	book_res = book_res_in
	var book_texture: CompressedTexture2D
	match book_res.genre:
		BookRes.GENRE.BESTSELLERS:
			match book_res.sort:
				BookRes.SORT.TOP:
					pass
				BookRes.SORT.MIDDLE:
					pass
				BookRes.SORT.BOTTOM:
					pass
			book_texture = best_books.pick_random()
		BookRes.GENRE.SCIFI:
			match book_res.sort:
				BookRes.SORT.TOP:
					book_texture = scifi_books_top.pick_random()
				BookRes.SORT.MIDDLE:
					book_texture = scifi_books.pick_random()
				BookRes.SORT.BOTTOM:
					book_texture = scifi_books_bottom.pick_random()
		BookRes.GENRE.CLASSICS:
			match book_res.sort:
				BookRes.SORT.TOP:
					book_texture = classic_books_top.pick_random()
				BookRes.SORT.MIDDLE:
					book_texture = classic_books.pick_random()
				BookRes.SORT.BOTTOM:
					book_texture = classic_books_bottom.pick_random()
	book_mesh.get_surface_override_material(0).set_shader_parameter("book_texture", book_texture)
	var book_name = book_texture.load_path
	book_name = book_name.rsplit(".png")[0]
	book_name = book_name.rsplit("/")[-1]
	book_res.name = book_name

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
	stop_inspect()


func seperate_mesh() -> MeshInstance3D:
	remove_child(book_mesh)
	return book_mesh


func destroy() -> void:
	animation_player.play("destroy")


func inspect() -> void:
	mesh_animation_player.play("inspect")


func stop_inspect() -> void:
	mesh_animation_player.play("RESET")
