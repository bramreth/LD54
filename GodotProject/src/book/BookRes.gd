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
