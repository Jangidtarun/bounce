extends KinematicBody2D



func _on_Area2D_area_entered(_area):
	$AnimatedSprite.play()
	print("spring pressed")
	$AnimatedSprite.stop()
	
