extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 100.0

var screen_width
var screen_height

var stomp_width = 64
var stomp_height = 16

func _ready():
	var sc = get_viewport_rect().size
	screen_width = sc.x
	screen_height = sc.y

var dir = 1.0

func _physics_process(_delta):
	if(position.x >= screen_width - stomp_width/2.0):
		dir = -1
	elif(position.x <= stomp_width/2.0):
		dir = 1
	velocity.x = speed*dir
	velocity = move_and_slide(velocity)
