extends Label

var score: int = 0

func _ready() -> void:
	UiEventBus.score_changed.connect(score_changed)
	UiEventBus.score_set.connect(score_set)


func score_changed(change: int) -> void:
	score += change
	update_text()


func score_set(new_score: int) -> void:
	score = new_score
	update_text()


func update_text() -> void:
	text = "Score: " + str(score)
