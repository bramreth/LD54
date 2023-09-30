extends CanvasLayer

@export var hands: Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shelf_label: Label = %ShelfLabel
@onready var color_label: Label = %ColorLabel
@onready var book_name: Label = %BookName
@onready var inspector_panel: PanelContainer = $Inspector/InspectorPanel

var last_book: Book = null:
	set(value):
		if value != last_book:
			last_book = value
			book_name.text = last_book.book_res.name
			shelf_label.text = String(BookRes.SORT.keys()[last_book.book_res.sort])
			color_label.text = String(BookRes.GENRE.keys()[last_book.book_res.genre])
			inspector_panel.get("theme_override_styles/panel").border_color = BookRes.map_color(last_book.book_res.genre)

func _process(delta: float) -> void:
	if hands.current_book:
		animation_player.stop()
		animation_player.play("Inspect")
		last_book = hands.current_book
