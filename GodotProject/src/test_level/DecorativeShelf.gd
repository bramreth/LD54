extends Node3D


@onready var shelf_mesh: CSGBox3D = $CSGBox3D

@export var genre: BookRes.GENRE = BookRes.GENRE.BESTSELLERS

func _ready() -> void:
	shelf_mesh.material.albedo_color = BookRes.map_color(genre)
