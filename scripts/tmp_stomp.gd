extends KinematicBody2D

var can_play = false

func _process(delta):
	if can_play:
		$AnimatedSprite.play()
		yield(get_tree().create_timer(1),"timeout")
