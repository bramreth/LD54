extends Resource
class_name BookRes

enum GENRE {
	BESTSELLERS,
	SCIFI,
	CLASSICS
}

enum SORT {
	TOP,
	MIDDLE,
	BOTTOM
}

@export var name := "Name"
@export var genre: GENRE = GENRE.BESTSELLERS
@export var sort: SORT = SORT.TOP

const scifi_color: Color = Color(0.34901961684227, 0.43921568989754, 0.44705882668495)
const classic_color: Color = Color(0.33333298563957, 0.16470600664616, 0.10588199645281)
const best_color: Color = Color(0.59215700626373, 0.43529400229454, 0.215685993433)

static func create_random() -> BookRes:
	var book = BookRes.new()
	book.genre = GENRE.values().pick_random()
	book.sort = SORT.values().pick_random()
	return book

func get_color() -> Color:
	var color_map := {
		GENRE.BESTSELLERS: best_color,
		GENRE.SCIFI: scifi_color,
		GENRE.CLASSICS: classic_color
	}
	return color_map[genre]

