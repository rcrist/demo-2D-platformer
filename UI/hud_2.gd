extends CanvasLayer

const MAX_HEALTH = 100
var health : int = MAX_HEALTH

const MIN_SCORE = 0
var score = MIN_SCORE

func _ready():
	update_score_and_health()
	$HealthBar.max_value = MAX_HEALTH
	$HealthBar.value = health
	$ScoreLabel.text = str(MIN_SCORE)
	HealthManager.connect("health_changed", health_changed)
	ScoreManager.connect("score_changed", score_changed)

func health_changed(new_value):
	health = new_value
	update_score_and_health()
	
func score_changed(new_value):
	score = new_value
	update_score_and_health()

func update_score_and_health():
	$ScoreLabel.text = str(score)
	$HealthBar.value = health

func _on_pause_texture_button_pressed() -> void:
	GameManager.pause_game()
