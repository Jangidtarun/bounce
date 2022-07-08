extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var size = get_viewport_rect().size
	position.x = clamp(position.x, 0, size.x)
