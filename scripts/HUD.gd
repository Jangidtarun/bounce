extends CanvasLayer

signal start_game

func update_score(score):
	$score.text = str(score)

func _ready():
	pass # Replace with function body.

func _on_start_button_pressed():
	$start_button.hide()
	emit_signal("start_game")
